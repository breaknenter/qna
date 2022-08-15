class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  after_action  :publish_answer, only: :create

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    return unless current_user.author_of?(answer)

    if answer.update(answer_params.reject { |key| key['files'] })
      if answer_params[:files].present?
        answer_params[:files].each { |file| answer.files.attach(file) }
      end
    end

    # @question = answer.question
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  def best
    answer.best! if current_user.author_of?(answer.question)

    @answer = answer
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.with_attached_files.find(params[:id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:text,
                                   files: [],
                                   links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{question.id}/answers",
      { answer: answer,
        files:  get_files,
        links:  answer.links }
      )
  end

  def get_files
    answer.files.map do |f|
      { id:   f.id,
        name: f.filename.to_s,
        url:  url_for(f) }
    end
  end
end

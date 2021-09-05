class AnswersController < ApplicationController
  before_action :authenticate_user!

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
    params.require(:answer).permit(:text, files: [])
  end
end

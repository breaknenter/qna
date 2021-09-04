class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)

      @question = answer.question
    end
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

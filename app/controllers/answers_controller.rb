class AnswersController < ApplicationController
  def create
    @answer = question.answers.create(answer_params)
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:text)
  end
end

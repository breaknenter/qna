class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to question, notice: 'Answer created'
    else
      flash.now[:alert] = 'Answer not created'
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question, notice: 'Your answer delete'
    else
      redirect_to question, alert: 'You cannot delete someone else answer'
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:text)
  end
end

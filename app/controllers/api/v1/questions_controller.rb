class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question, only: %i[show update destroy]

  def index
    questions = Question.all

    render json: questions
  end

  def show
    render json: question
  end

  private

  def question
    Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :text)
  end
end

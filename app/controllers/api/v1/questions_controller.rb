class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question, only: %i[show update destroy answers]

  def index
    questions = Question.all

    render json: questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question, serializer: QuestionSerializer
  end

  def answers
    render json: question.answers
  end

  private

  def question
    Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :text)
  end
end

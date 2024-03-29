class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question, only: %i[show update destroy answers]

  authorize_resource

  def index
    questions = Question.all

    render json: questions, each_serializer: QuestionsSerializer
  end

  def create
    @question = current_resource_owner.questions.build(question_params)

    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def destroy
    @question.destroy

    render json: { message: 'Question deleted' }
  end

  def answers
    render json: @question.answers
  end

  private

  def question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :text)
  end
end

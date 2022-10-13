class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: %i[create update show destroy]
  before_action :set_question, only: :create

  def create
    @answer = current_resource_owner.answers.build(answer_params)
    @answer.question = @question
    
    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @answer
  end

  def destroy
    @answer.destroy

    render json: { message: 'Answer deleted' }
  end

  private

  def set_answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def set_question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : @answer.question
  end

  def answer_params
    params.require(:answer).permit(:text)
  end
end

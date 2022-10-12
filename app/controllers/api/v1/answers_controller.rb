class Api::V1::AnswersController < Api::V1::BaseController
  before_action :answer, only: %i[create update show destroy]

  def show
    render json: answer
  end

  private

  def answer
    Answer.find(params[:id])
  end
end

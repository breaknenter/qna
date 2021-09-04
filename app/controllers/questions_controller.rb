class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    question
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question created.'
    else
      render :new
    end
  end

  def update
    return unless current_user.author_of?(question)

    if question.update(question_params.reject { |key| key['files'] })
      if question_params[:files].present?
        question_params[:files].each { |file| question.files.attach(file) }
      end
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question delete'
    else
      redirect_to question, alert: 'You cannot delete someone else question'
    end
  end

  private

  def question
    @question ||= Question.with_attached_files.find(params[:id])
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :text, files: [])
  end
end

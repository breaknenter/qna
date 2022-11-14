class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :question, only: %i[update destroy]
  before_action -> { gon.author_id = current_user&.id }, only: :show
  after_action  :publish_question,   only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_reward
  end

  def show
    @answer = Answer.new
    @answer.links.build

    build_links

    question

    @subscription = @question.subscriptions.find_by(subscriber: current_user) if current_user
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
    if question.update(question_params.reject { |key| key['files'] })
      if question_params[:files].present?
        question_params[:files].each { |file| question.files.attach(file) }
      end
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question delete'
  end

  private

  def question
    @question ||= Question.with_attached_files.find(params[:id])
  end

  helper_method :question

  def question_params
    params.require(:question).permit(
      :title,
      :text,
      files: [],
      links_attributes:  [:id, :name, :url,   :_destroy],
      reward_attributes: [:id, :name, :image, :_destroy]
    )
  end

  def build_links
    question.links.build unless question.links
  end

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: {question: question}
        )
      )
  end
end

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create

  def create
    @subscription = @question.subscriptions.create(subscriber: current_user)

    render :subscription
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @question = @subscription.question
    @subscription.destroy

    render :subscription
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end

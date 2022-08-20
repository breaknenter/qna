module Commented
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: :create_comment
    before_action :set_commentable,    only: :create_comment
    after_action  :publish_comment,    only: :create_comment
  end

  def create_comment
    @comment = set_commentable.comments.build(comment_params)
    @comment.author = current_user
    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    question_id = @comment.commentable_type == 'Question' ? @commentable.id : @commentable.question_id

    ActionCable.server.broadcast(
      "question_#{question_id}/comments",
      @comment
      )
  end

  def comment_params
    params.require(:comment).permit(:text)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end

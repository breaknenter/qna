class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:question_id]}/comments"
  end
end

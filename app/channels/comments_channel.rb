class CommentsChannel < ApplicationCable::Channel
  def subscribed
    commentable_type = params[:commentable_type].constantize
    commentable = commentable_type.find(params[:commentable_id])
    stream_for commentable if commentable
  end
end

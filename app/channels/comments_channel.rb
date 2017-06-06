class CommentsChannel < ApplicationCable::Channel
  def subscribed
    type = params[:commentable_type]
    id   = params[:commentable_id]
    stream_for "comment/#{type}#{id}"
  end
end

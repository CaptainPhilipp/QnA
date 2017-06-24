class CommentBroadcaster
  def initialize(comment)
    @comment = comment
  end

  def call
    broadcast! if comment.errors.empty?
  end

  private

  attr_reader :comment

  def broadcast!
    CommentsChannel.broadcast_to channel_adress, data
  end

  def channel_adress
    "comment/#{commentable.class}#{commentable.id}"
  end

  def commentable
    @commentable ||= comment.commentable
  end

  def data
    ApplicationController.render json: comment
  end
end

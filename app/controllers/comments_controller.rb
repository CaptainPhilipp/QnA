class CommentsController < ApplicationController
  after_action :broadcast_comment, only: [:create]

  def create
    @comment = Comment.new comment_params
    @comment.user = current_user
    @comment.save
  end

  private

  def broadcast_comment
    return unless @comment.persisted?
    commentable = @comment.commentable
    type = commentable.class
    id   = commentable.id
    CommentsChannel.broadcast_to "comment/#{type}#{id}",
      ApplicationController.render(json: @comment)
  end

  def comment_params
    params.require(:comment).permit %i(body commentable_id commentable_type)
  end
end

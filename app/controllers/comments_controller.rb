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
    CommentsChannel.broadcast_to @comment.commentable, ApplicationController.render(@comment)
  end

  def comment_params
    params.require(:comment).permit %i(body commentable_id commentable_type)
  end
end

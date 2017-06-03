class CommentsController < ApplicationController
  def create
    @comment = Comment.new comment_params
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit %i(body commentable_id commentable_type)
  end
end

class CommentsController < ApplicationController
  after_action :broadcast_comment, only: [:create]

  def create
    @comment = Comment.create(comment_params.merge user_id: current_user.id)
  end

  private

  def broadcast_comment
    return if @comment.errors.any?
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

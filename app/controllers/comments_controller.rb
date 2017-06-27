class CommentsController < ApplicationController
  after_action :broadcast_comment, only: [:create]
  after_action :verify_authorized

  def create
    authorize Comment
    @comment = Comment.create(comment_params.merge user_id: current_user.id)
  end

  private

  def broadcast_comment
    Comments::Broadcaster.new(@comment).call
  end

  def comment_params
    params.require(:comment).permit %i(body commentable_id commentable_type)
  end
end

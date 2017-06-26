module Comments
  class Broadcaster
    def initialize(comment)
      @comment = comment
    end

    def call
      broadcast! if comment.valid?
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
end

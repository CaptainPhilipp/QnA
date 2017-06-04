$(document).on 'turbolinks:load', ->
  commentables = $('[data-commentable-id][data-commentable-type]')

  commentables.each (i) ->
    commentable = $(commentables[i])
    id = commentable.data('commentableId')
    ctype = commentable.data('commentableType')

    App['comments' + ctype + id] =
      App.cable.subscriptions.create {
        channel: "CommentsChannel",
        commentable_id:   id,
        commentable_type: ctype
      }, {
        received: (data) ->
          commentable.find('.comments').prepend(data)
      }

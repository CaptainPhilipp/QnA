$(document).on 'turbolinks:load', ->
  $('.rating a').bind 'ajax:success', (e, data, status, xhr) ->
    respond = $.parseJSON(xhr.responseText)
    $('.rating .score').replaceWith(respond)

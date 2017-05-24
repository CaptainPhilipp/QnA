$(document).on 'turbolinks:load', ->
  $('.rating.rated .change_rate').hide()
  $('.rating.rated .cancel_voice').show()

  $('.rating .cancel_voice a').bind 'ajax:success', (e, data, status, xhr) ->
    id = '#rateable_' + $(this).data('rateableId')
    respond = $.parseJSON(xhr.responseText)
    $(id + ' .score').html(respond)
    $(id + ' .cancel_voice').hide()
    $(id + ' .change_rate').show()

  $('.rating .change_rate a').bind 'ajax:success', (e, data, status, xhr) ->
    id = '#rateable_' + $(this).data('rateableId')
    respond = $.parseJSON(xhr.responseText)
    $(id + ' .score').html(respond)
    $(id + ' .change_rate').hide()
    $(id + ' .cancel_voice').show()

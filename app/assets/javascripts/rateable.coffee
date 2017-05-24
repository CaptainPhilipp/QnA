$(document).on 'turbolinks:load', ->
  toggleControl('.rating.rated')

  $('.rating .cancel_voice a').bind 'ajax:success', (e, data, status, xhr) ->
    ratingAction(this, xhr)

  $('.rating .change_rate a').bind 'ajax:success', (e, data, status, xhr) ->
    ratingAction(this, xhr)

toggleControl = (context) ->
  $(context + ' .cancel_voice').toggle()
  $(context + ' .change_rate').toggle()

getRateableId = (this_) ->
  '#rateable_' + $(this_).data('rateableId')

ratingAction = (this_, xhr) ->
  id = getRateableId(this_)
  response = $.parseJSON(xhr.responseText)
  $(id + ' .score').html(response)
  toggleControl(id)

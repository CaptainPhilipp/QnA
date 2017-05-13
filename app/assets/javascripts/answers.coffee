# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
local_selector = (this_, selector)->
  id = $(this_).data('answerId')
  '#answer_' + id + ' ' + selector

$(document).on 'turbolinks:load', ->
  $('.answer_edit_link').click (e)->
    e.preventDefault()
    $(".edit-form").hide()
    $('.body').show()
    $(local_selector(this, '.body')).hide()
    $(local_selector(this, '.edit-form')).show()

  $('.cancel_answer_edit_link').click (e) ->
    e.preventDefault()
    $(local_selector(this, '.edit-form')).hide()
    $(local_selector(this, '.body')).show()

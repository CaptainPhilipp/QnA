# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
answer_id = (current)->
  '#answer_' + $(current).data 'answerId'

$(document).on "turbolinks:load", ->
  $('.answer_edit_link').click (e)->
    e.preventDefault()
    $(".edit-form").hide()
    $('.body').show()
    $(answer_id(this) + " .body").hide()
    $(answer_id(this) + " .edit-form").show()

  $('answer_cancel_edit_link').click (e) ->
    e.preventDefault()
    $(answer_id(this) + ".edit-form").hide()
    $(answer_id(this) + '.body').show()
    $(answer_id(this) + " form #answer_body").val('')

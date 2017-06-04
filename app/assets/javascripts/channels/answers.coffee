$(document).on 'turbolinks:load', ->
  questionId = $('#question')?.data('questionId')
  return if !questionId

  answers = $('#answers')

  App.answers = App.cable.subscriptions.create { channel: 'AnswersChannel', question_id: questionId },
    received: (data) ->
      dataHash = JSON.parse(data)
      partial = App.utils.render('answer', dataHash)
      answers.append(partial)

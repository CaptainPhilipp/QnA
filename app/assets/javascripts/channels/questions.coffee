$(document).on 'turbolinks:load', ->
  questions = $('#questions')
  return if questions == undefined
  isActiveChannel = questions.data('questionsChannel')
  return if isActiveChannel == undefined

  App.questions = App.cable.subscriptions.create "QuestionsChannel",
    received: (data) ->
      question = JSON.parse(data)
      partial = App.utils.render('question', question)
      questions.append partial

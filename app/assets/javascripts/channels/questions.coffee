App.questions = App.cable.subscriptions.create "QuestionsChannel",
  received: (data) ->
    $('#questions').append data

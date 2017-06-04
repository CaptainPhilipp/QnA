App.utils =
  render: (template, data) ->
    JST["templates/#{template}"](data)

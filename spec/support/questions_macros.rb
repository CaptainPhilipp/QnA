module QuestionsMacros
  def create_question_with_form(attributes = nil)
    attributes ||= { title: 'Question title', body: 'Question body' }

    fill_in Question.human_attribute_name(:title), with: attributes[:title]
    fill_in Question.human_attribute_name(:body),  with: attributes[:body]
    click_on I18n.t(:create, scope: 'questions.form')
  end
end

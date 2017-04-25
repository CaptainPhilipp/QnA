module QuestionsMacros
  def new_question_from_index
    visit questions_path
    click_link I18n.t('questions.index.create')
  end
end

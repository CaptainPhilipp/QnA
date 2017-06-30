class QuestionSerializer < QuestionsSerializer
  has_many :answers
  has_many :comments
  has_many :attachments
end

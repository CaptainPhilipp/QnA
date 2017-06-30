class QuestionSerializer < QuestionsSerializer
  has_many :answers, each_serializer: AnswersSerializer
  has_many :comments
  has_many :attachments
end

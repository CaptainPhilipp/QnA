class AnswerSerializer < AnswersSerializer
  has_many :comments
  has_many :attachments
end

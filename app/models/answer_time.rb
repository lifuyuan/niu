class AnswerTime
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :question

  field :begin_time, type: DateTime
end

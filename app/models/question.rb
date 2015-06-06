class Question
  include Mongoid::Document
  field :difficulty, type: String
  field :show_date, type: Date
  field :content, type: String
  field :answer, type: String
end

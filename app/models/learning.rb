class Learning
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :question
  field :difficulty, type: String
  field :learning_date, type: Date
  field :answer, type: String
  field :answer_number, type: BigDecimal
  field :right_answer_number, type: BigDecimal
  field :time_spent, type: BigDecimal
  field :score, type: BigDecimal
  field :is_favorite, type: String

  def to_html
  end
  
  before_create do
    self.difficulty = self.question.difficulty
    self.learning_date = Time.now
    standard_answer = self.question.answer.split("|")
    my_answer = self.answer.split("|")
    self.answer_number = standard_answer.count
    self.right_answer_number = 0
    (0..answer_number-1).each {|i| self.right_answer_number += 1 if standard_answer[i] == my_answer[i]}
    self.score = self.right_answer_number*2
  end

  after_create do 
    self.user.update_attributes(score: self.user.score || 0 + self.score)
  end
end

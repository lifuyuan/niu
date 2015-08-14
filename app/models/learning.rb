class Learning
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :question
  field :difficulty, type: String
  field :learning_date, type: Date
  field :answer, type: String
  field :answer_number, type: Integer
  field :right_answer_number, type: Integer
  field :time_spent, type: Integer
  field :score, type: Integer
  field :ranking, type: String
  field :is_favorite, type: String
  field :learning_hour, type: Integer
  field :grade, type: String

  def to_html
    content = self.question.content
    standard_answer = self.question.answer.split("|")
    my_answer = self.answer.split("|")
    (0..answer_number-1).each {|i| content.sub!("_", "<u>#{my_answer[i]}</u><span style='color: #c0392b; display:inline; font-size: 15px;'>[#{standard_answer[i]}]</span>")}
    content
  end

  def to_html_android
    content_array = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{self.question.content}&nbsp;".split('_')
    for i in 0..content_array.length-2
      content_array[i].insert(-2, "<span class='prefix_show'>")
      content_array[i].insert(-1, "</span>")
      content_array[i].gsub!("\r\n", "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
    end
    standard_answer = self.question.answer.split("|")
    my_answer = self.answer.split("|")
    new_content = content_array.join("___")
    (0..answer_number-1).each do |i|
      if (my_answer[i] || "").gsub(' ','') == standard_answer[i]
        new_content.sub!("___", "<u style='color: #9ce159;'>#{my_answer[i]}</u>")
      else
        new_content.sub!("___", "<u style='color: #9ce159;'>#{my_answer[i]}</u><span style='color: red; display:inline;'>[#{standard_answer[i]}]</span>")
      end
    end
    new_content
  end

  def spent
    count_h = time_spent.to_i/3600
    count_m = (time_spent - 3600*count_h).to_i/60
    count_s = (time_spent - 3600*count_h - count_m*60).to_i
    if count_h > 0
      sprintf("%.2d:%.2d:%.2d", count_h, count_m, count_s)
    else
      sprintf("%.2d:%.2d", count_m, count_s)
    end
  end


  
  before_create do
    self.difficulty = self.question.difficulty
    self.learning_date = Time.now
    self.learning_hour = Time.now.strftime("%H").to_i
    standard_answer = self.question.answer.split("|")
    my_answer = self.answer.split("|")
    self.answer_number = standard_answer.count
    self.right_answer_number = 0
    self.time_spent = (Time.now - self.question.answer_times.where(user: self.user).first.begin_time).to_i
    (0..answer_number-1).each {|i| self.right_answer_number += 1 if standard_answer[i] == (my_answer[i] || "").gsub(' ','')}
    self.score = self.right_answer_number*2 - self.answer_number
  end

  after_create do 
    self.user.update_attributes(score: self.user.score || 0 + self.score)
    self.ranking = self.calc_ranking
    self.grade = self.user.grade
    self.save
  end

  def calc_ranking
    rank = 0
    learning_array = self.question.learnings.desc(:right_answer_number).asc(:time_spent).to_a
    (0..learning_array.size-1).each do |i|
      rank = i+1 if self.id == learning_array[i].id
    end
    "#{rank}/#{self.question.learnings.count}"
  end

  def current_ranking
    rank = 0
    learning_array = self.question.learnings.desc(:right_answer_number).asc(:time_spent).to_a
    (0..learning_array.size-1).each do |i|
      rank = i+1 if self.id == learning_array[i].id
    end
    "#{rank}/#{self.question.learnings.count}"
  end

end

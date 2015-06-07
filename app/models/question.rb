class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  
  DIFFICULTY_ITEM = [[nil, nil], ['一颗心难度', 'one'], ['两颗心难度', 'two'], ['三颗心难度', 'three']]
  field :difficulty, type: String
  field :show_date, type: Date
  field :content, type: String
  field :answer, type: String
  has_many :learnings, :dependent => :destroy

  validates_presence_of :difficulty, :show_date, :content, :answer
  before_validation :all_in_one

  def to_html
		self.content.gsub("_", "<input name='answer[]' type='text' style='display:inline;width: 6%;border-top: none;border-left: none;border-right: none;height: 5px;border-bottom-color: #2c3e50;background-color: #ebebeb;'>")
	end

	def all_in_one
		if content.present? && content.scan(/[\w]_/).count == 0
			errors.add(:content, "您输入的题目有误，没有需要学生输入的单词！")
		end
		if content.present? && answer.present?
			if content.scan(/[\w]_/).count != answer.split("|").count
				errors.add(:answer, "题目空格数与答案数不一致，请检查！")
			end
		end
	end
end

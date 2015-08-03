class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  
  DIFFICULTY_ITEM = [[nil, nil], ['一颗星难度', 'one'], ['两颗星难度', 'two'], ['三颗星难度', 'three']]
  field :difficulty, type: String
  field :show_date, type: Date
  field :content, type: String
  field :answer, type: String
  has_many :learnings, :dependent => :destroy
  has_many :answer_times, :dependent => :destroy

  validates_presence_of :difficulty, :show_date, :content, :answer
  before_validation :all_in_one
  validates :show_date, uniqueness: { scope: :difficulty,
    message: "该日期已创建过相同难度等级的题目" }

  def to_html
		self.content.gsub("_", "<input name='answer[]' type='text' style='display:inline;width: 6%;border-top: none;border-left: none;border-right: none;height: 5px;border-bottom-color: #2c3e50;background-color: #ebebeb; box-shadow: none;'>")
	end

  def to_html_android
    content_array = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style='color: #9ce159;'>[#{self.show_date.strftime("%Y-%m-%d")}]</span>#{self.content}&nbsp;".split('_')
    for i in 0..content_array.length-2
      content_array[i].insert(-2, "<span class='prefix'>")
      content_array[i].insert(-1, "</span>")
      content_array[i].gsub!("\r\n", "<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
    end
    content_array.join("<input name='answer[]' type='text' style='display:inline;padding-bottom: 3px;padding-left: 0px;padding-right: 0px;width: 67px;border-top: none;border-left: none;border-right: none;height: 5px;border-bottom-color: #9ce159;background: transparent; box-shadow: none;'>")
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

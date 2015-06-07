module ApplicationHelper
	def to_html(content)
		n = 0
		content.gsub("_", "<input name='answer#{n+=1}' type='text'>")
	end
end

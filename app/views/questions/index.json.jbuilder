json.array!(@questions) do |question|
  json.extract! question, :id, :difficulty, :show_date, :content, :answer
  json.url question_url(question, format: :json)
end

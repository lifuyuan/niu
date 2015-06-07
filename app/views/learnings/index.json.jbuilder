json.array!(@learnings) do |learning|
  json.extract! learning, :id, :difficulty, :learning_date, :answer, :answer_number, :right_answer_number, :time_spent, :score, :is_favorite, :question_id
  json.url learning_url(learning, format: :json)
end

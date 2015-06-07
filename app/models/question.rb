class Question
  include Mongoid::Document
  DIFFICULTY_ITEM = [[nil, nil], ['一颗心难度', 'one'], ['两颗心难度', 'two'], ['三颗心难度', 'three']]
  field :difficulty, type: String
  field :show_date, type: Date
  field :content, type: String
  field :answer, type: String
end

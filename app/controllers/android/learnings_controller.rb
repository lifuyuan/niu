class Android::LearningsController < ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  respond_to :html

  def new_learning
    difficulty = params[:difficulty] || current_user.default_difficulty
    @question = Question.where(show_date: "#{Time.now.strftime("%Y%m%d")}", difficulty: difficulty).first
    @learning = Learning.new
    render(:layout => "layouts/android")
  end

  def create_learning
    @question = Question.where(id: params[:question_id]).first
    @learning = Learning.new(answer: params[:answer].join("|"))
    @learning.question = @question
    @learning.user = current_user
    @learning.save
    redirect_to "/android/learnings/#{@learning.id}/show_learning"
  end

  def show_learning
    @learning = Learning.find(params[:learning_id])
    render(:layout => "layouts/android")
  end

end

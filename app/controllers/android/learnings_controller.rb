class Android::LearningsController < ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  respond_to :html

  def new_learning
    @question = Question.where(show_date: "#{Time.now.strftime("%Y%m%d")}", difficulty: params[:difficulty_id]).first
    @learning = Learning.new
    render(:layout => "layouts/android")
  end

  def create_learning
  end

  def show_learning
  end

end

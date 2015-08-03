class Android::LearningsController < ApplicationController
  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!

  respond_to :html

  def new_learning
    @difficulty = params[:difficulty] || @user.default_difficulty
    @learning = Learning.new
    if @question = Question.where(show_date: "#{Time.now.strftime("%Y%m%d")}", difficulty: @difficulty).first
      if learning = @question.learnings.where(user: @user).first
        redirect_to "/android/learnings/#{learning.id}/show_learning?token=#{@user.authentication_token}" and return
      end

      if answer_time = @question.answer_times.where(user: @user).first
      else
        AnswerTime.create(user: @user, question: @question, begin_time: Time.now)
      end
    end
    render(:layout => "layouts/android")
  end

  def create_learning
    @question = Question.where(id: params[:question_id]).first
    @learning = Learning.new(answer: params[:answer].join("|"))
    @learning.question = @question
    @learning.user = @user
    @learning.save
    redirect_to "/android/learnings/#{@learning.id}/show_learning?token=#{@user.authentication_token}"
  end

  def show_learning
    @learning = Learning.where(id: params[:learning_id]).first
    @difficulty = @learning.question.difficulty
    render(:layout => "layouts/android")
  end

  def lock
    @user.update_attributes(default_difficulty: params[:difficulty_value])
    respond_to do |format|
      format.js
    end
  end

  def keep
    if @learning = Learning.where(id: params[:learning_id]).first
      @learning.update_attributes(is_favorite: "yes")
      respond_to do |format|
        format.js
      end
    end
  end

  def learning_info
    @rank_one = "- -"
    @rank_two = "- -"
    @rank_three = "- -"
    if learning_one = @user.learnings.where(learning_date: "#{(Time.now-1.day).strftime("%Y%m%d")}", difficulty: "one").first
      @rank_one = learning_one.current_ranking
    end
    if learning_two = @user.learnings.where(learning_date: "#{(Time.now-1.day).strftime("%Y%m%d")}", difficulty: "two").first
      @rank_two = learning_two.current_ranking
    end
    if learning_three = @user.learnings.where(learning_date: "#{(Time.now-1.day).strftime("%Y%m%d")}", difficulty: "three").first
      @rank_three = learning_three.current_ranking
    end
    render(:layout => "layouts/android")
  end

  def learning_record
    @learnings = @user.learnings.desc(:created)
    render(:layout => "layouts/android")
  end

  def favorite
    @learnings = @user.learnings.where(is_favorite: "yes").desc(:created)
    render(:layout => "layouts/android")
  end

  def top_ten_yesterday
    render(:layout => "layouts/android")
  end

  def top_ten
    render(:layout => "layouts/android")
  end

  def learning_show
    @learning = Learning.where(id: params[:learning_id]).first
    @back = {"record"=>"learning_record", "favorite"=>"favorite"}[params[:from]]
    render(:layout => "layouts/android")
  end

end

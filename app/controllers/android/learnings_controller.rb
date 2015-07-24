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
        count = (Time.now - answer_time.begin_time).to_i
        @count_h = count/3600
        @count_m = (count - 3600*@count_h).to_i/60
        @count_s = (count - 3600*@count_h - @count_m*60).to_i
      else
        AnswerTime.create(user: @user, question: @question, begin_time: Time.now)
        @count_h = 0
        @count_m = 0
        @count_s = 0
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

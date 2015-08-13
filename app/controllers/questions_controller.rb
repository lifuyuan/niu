class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :authenticate_admin_activity

  respond_to :html

  def index
    @questions = Question.all.desc(:show_date)
    respond_with(@questions)
  end

  def show_questions
    @questions = Question.all.desc(:show_date)
    respond_with(@questions)
  end

  def show
    redirect_to "/questions/show_questions"
  end

  def new
    @question = Question.new
    respond_with(@question)
  end

  def edit
    unless @question.can_edit?
      redirect_to questions_path, notice: "只能修改今天之后的题目" and return
    end
  end

  def create
    @question = Question.new(question_params)
    @question.save
    respond_with(@question)
  end

  def update
    unless @question.can_edit?
      redirect_to questions_path, notice: "只能修改今天之后的题目" and return
    end
    @question.update(question_params)
    flash[:notice] = "题目修改成功"
    respond_with(@question)
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  def show_statistics
    @show_date = params[:show_date].blank? ?  "#{(Time.now-1.day).strftime("%Y-%m-%d")}" : params[:show_date]
    logger.info "show_date:==========#{@show_date}"
    redirect_to '/questions/show_statistics', notice: "只能查询今天之前的数据" and return  unless (Date.parse(@show_date) <=> Date.parse(Time.now.strftime("%Y-%m-%d"))) == -1
    @next_date = (Date.parse(@show_date) + 1.day).strftime("%Y-%m-%d")

    if Learning.where(learning_date: @show_date, difficulty: "one").count == 0
      @average_accuracy_one = "0/0"
      @average_time_one = "00:00"
    else
      @average_accuracy_one = "#{Learning.where(learning_date: @show_date, difficulty: "one").sum{|l| l.right_answer_number}.to_f/Learning.where(learning_date: @show_date, difficulty: "one").count }/#{Learning.where(learning_date: @show_date, difficulty: "one").first.answer_number}"
      avr_time = Learning.where(learning_date: @show_date, difficulty: "one").sum{|l| l.time_spent}/Learning.where(learning_date: @show_date, difficulty: "one").count
      count_h = avr_time.to_i/3600
      count_m = (avr_time - 3600*count_h).to_i/60
      count_s = (avr_time - 3600*count_h - count_m*60).to_i
      if count_h > 0
        @average_time_one = sprintf("%.2d:%.2d:%.2d", count_h, count_m, count_s)
      else
        @average_time_one = sprintf("%.2d:%.2d", count_m, count_s)
      end
    end

    if Learning.where(learning_date: @show_date, difficulty: "two").count == 0
      @average_accuracy_two = "0/0"
      @average_time_two = "00:00"
    else
      @average_accuracy_two = "#{Learning.where(learning_date: @show_date, difficulty: "two").sum{|l| l.right_answer_number}.to_f/Learning.where(learning_date: @show_date, difficulty: "two").count }/#{Learning.where(learning_date: @show_date, difficulty: "two").first.answer_number}"
      avr_time = Learning.where(learning_date: @show_date, difficulty: "two").sum{|l| l.time_spent}/Learning.where(learning_date: @show_date, difficulty: "two").count
      count_h = avr_time.to_i/3600
      count_m = (avr_time - 3600*count_h).to_i/60
      count_s = (avr_time - 3600*count_h - count_m*60).to_i
      if count_h > 0
        @average_time_two = sprintf("%.2d:%.2d:%.2d", count_h, count_m, count_s)
      else
        @average_time_two = sprintf("%.2d:%.2d", count_m, count_s)
      end
    end

    if Learning.where(learning_date: @show_date, difficulty: "three").count <= 0
      @average_accuracy_three = "0/0"
      @average_time_three = "00:00"
    else
      @average_accuracy_three = "#{Learning.where(learning_date: @show_date, difficulty: "three").sum{|l| l.right_answer_number}.to_f/Learning.where(learning_date: @show_date, difficulty: "three").count }/#{Learning.where(learning_date: @show_date, difficulty: "three").first.answer_number}"
      avr_time = Learning.where(learning_date: @show_date, difficulty: "three").sum{|l| l.time_spent}/Learning.where(learning_date: @show_date, difficulty: "three").count
      count_h = avr_time.to_i/3600
      count_m = (avr_time - 3600*count_h).to_i/60
      count_s = (avr_time - 3600*count_h - count_m*60).to_i
      if count_h > 0
        @average_time_three = sprintf("%.2d:%.2d:%.2d", count_h, count_m, count_s)
      else
        @average_time_three = sprintf("%.2d:%.2d", count_m, count_s)
      end
    end
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:difficulty, :show_date, :content, :answer)
    end
end

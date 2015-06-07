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
  end

  def create
    @question = Question.new(question_params)
    @question.save
    respond_with(@question)
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:difficulty, :show_date, :content, :answer)
    end
end

class LearningsController < ApplicationController
  before_action :set_learning, only: [:show, :edit, :update, :destroy]
  before_action :set_question

  respond_to :html

  def index
    @learnings = Learning.all
    respond_with(@learnings)
  end

  def show
    respond_with([@question, @learning])
  end

  def new
    @learning = Learning.new
    respond_with([@question, @learning])
  end

  def edit
  end

  def create
    @learning = Learning.new(answer: params[:answer].join("|"))
    @learning.question = @question
    @learning.user = current_user
    @learning.save
    respond_with([@question, @learning])
  end

  def update
    @learning.update(learning_params)
    respond_with([@question, @learning])
  end

  def destroy
    @learning.destroy
    respond_with([@question, @learning])
  end

  private
    def set_learning
      @learning = Learning.find(params[:id])
    end

    def learning_params
      params.require(:learning).permit(:answer)
    end

    def set_question
      @question = Question.find(params[:question_id])
    end
end

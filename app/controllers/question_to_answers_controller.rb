class QuestionToAnswersController < ApplicationController
  before_action :set_question_to_answer, only: %i[ show edit update destroy ]

  # GET /question_to_answers or /question_to_answers.json
  def index
    @question_to_answers = QuestionToAnswer.all
  end

  # GET /question_to_answers/1 or /question_to_answers/1.json
  def show
  end

  # GET /question_to_answers/new
  def new
    @question_to_answer = QuestionToAnswer.new
  end

  # GET /question_to_answers/1/edit
  def edit
  end

  # POST /question_to_answers or /question_to_answers.json
  def create
    @question_to_answer = QuestionToAnswer.new(question_to_answer_params)

    respond_to do |format|
      if @question_to_answer.save
        format.html { redirect_to question_to_answer_url(@question_to_answer), notice: "Question to answer was successfully created." }
        format.json { render :show, status: :created, location: @question_to_answer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question_to_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /question_to_answers/1 or /question_to_answers/1.json
  def update
    respond_to do |format|
      if @question_to_answer.update(question_to_answer_params)
        format.html { redirect_to question_to_answer_url(@question_to_answer), notice: "Question to answer was successfully updated." }
        format.json { render :show, status: :ok, location: @question_to_answer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question_to_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /question_to_answers/1 or /question_to_answers/1.json
  def destroy
    @question_to_answer.destroy

    respond_to do |format|
      format.html { redirect_to question_to_answers_url, notice: "Question to answer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question_to_answer
      @question_to_answer = QuestionToAnswer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def question_to_answer_params
      params.require(:question_to_answer).permit(:question_id, :answer_id)
    end
end

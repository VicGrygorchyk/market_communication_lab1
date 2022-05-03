require "test_helper"

class QuestionToAnswersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question_to_answer = question_to_answers(:one)
  end

  test "should get index" do
    get question_to_answers_url
    assert_response :success
  end

  test "should get new" do
    get new_question_to_answer_url
    assert_response :success
  end

  test "should create question_to_answer" do
    assert_difference('QuestionToAnswer.count') do
      post question_to_answers_url, params: { question_to_answer: { answer_id: @question_to_answer.answer_id, question_id: @question_to_answer.question_id } }
    end

    assert_redirected_to question_to_answer_url(QuestionToAnswer.last)
  end

  test "should show question_to_answer" do
    get question_to_answer_url(@question_to_answer)
    assert_response :success
  end

  test "should get edit" do
    get edit_question_to_answer_url(@question_to_answer)
    assert_response :success
  end

  test "should update question_to_answer" do
    patch question_to_answer_url(@question_to_answer), params: { question_to_answer: { answer_id: @question_to_answer.answer_id, question_id: @question_to_answer.question_id } }
    assert_redirected_to question_to_answer_url(@question_to_answer)
  end

  test "should destroy question_to_answer" do
    assert_difference('QuestionToAnswer.count', -1) do
      delete question_to_answer_url(@question_to_answer)
    end

    assert_redirected_to question_to_answers_url
  end
end

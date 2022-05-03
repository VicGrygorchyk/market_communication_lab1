require "application_system_test_case"

class QuestionToAnswersTest < ApplicationSystemTestCase
  setup do
    @question_to_answer = question_to_answers(:one)
  end

  test "visiting the index" do
    visit question_to_answers_url
    assert_selector "h1", text: "Question To Answers"
  end

  test "creating a Question to answer" do
    visit question_to_answers_url
    click_on "New Question To Answer"

    fill_in "Answer", with: @question_to_answer.answer_id
    fill_in "Question", with: @question_to_answer.question_id
    click_on "Create Question to answer"

    assert_text "Question to answer was successfully created"
    click_on "Back"
  end

  test "updating a Question to answer" do
    visit question_to_answers_url
    click_on "Edit", match: :first

    fill_in "Answer", with: @question_to_answer.answer_id
    fill_in "Question", with: @question_to_answer.question_id
    click_on "Update Question to answer"

    assert_text "Question to answer was successfully updated"
    click_on "Back"
  end

  test "destroying a Question to answer" do
    visit question_to_answers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Question to answer was successfully destroyed"
  end
end

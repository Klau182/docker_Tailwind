require "application_system_test_case"

class EvaluationsTest < ApplicationSystemTestCase
  setup do
    @evaluation = evaluations(:one)
  end

  test "visiting the index" do
    visit evaluations_url
    assert_selector "h1", text: "Evaluations"
  end

  test "should create evaluation" do
    visit evaluations_url
    click_on "New evaluation"

    fill_in "Body text", with: @evaluation.body_text
    fill_in "Description", with: @evaluation.description
    fill_in "Name", with: @evaluation.name
    fill_in "Types", with: @evaluation.types
    fill_in "User", with: @evaluation.user_id
    click_on "Create Evaluation"

    assert_text "Evaluation was successfully created"
    click_on "Back"
  end

  test "should update Evaluation" do
    visit evaluation_url(@evaluation)
    click_on "Edit this evaluation", match: :first

    fill_in "Body text", with: @evaluation.body_text
    fill_in "Description", with: @evaluation.description
    fill_in "Name", with: @evaluation.name
    fill_in "Types", with: @evaluation.types
    fill_in "User", with: @evaluation.user_id
    click_on "Update Evaluation"

    assert_text "Evaluation was successfully updated"
    click_on "Back"
  end

  test "should destroy Evaluation" do
    visit evaluation_url(@evaluation)
    click_on "Destroy this evaluation", match: :first

    assert_text "Evaluation was successfully destroyed"
  end
end

require "application_system_test_case"

class ChaptersTest < ApplicationSystemTestCase
  setup do
    @chapter = chapters(:one)
  end

  test "visiting the index" do
    visit chapters_url
    assert_selector "h1", text: "Chapters"
  end

  test "should create chapter" do
    visit chapters_url
    click_on "New chapter"

    fill_in "Body text", with: @chapter.body_text
    fill_in "Description", with: @chapter.description
    fill_in "Name", with: @chapter.name
    fill_in "Types", with: @chapter.types
    fill_in "User", with: @chapter.user_id
    click_on "Create Chapter"

    assert_text "Chapter was successfully created"
    click_on "Back"
  end

  test "should update Chapter" do
    visit chapter_url(@chapter)
    click_on "Edit this chapter", match: :first

    fill_in "Body text", with: @chapter.body_text
    fill_in "Description", with: @chapter.description
    fill_in "Name", with: @chapter.name
    fill_in "Types", with: @chapter.types
    fill_in "User", with: @chapter.user_id
    click_on "Update Chapter"

    assert_text "Chapter was successfully updated"
    click_on "Back"
  end

  test "should destroy Chapter" do
    visit chapter_url(@chapter)
    click_on "Destroy this chapter", match: :first

    assert_text "Chapter was successfully destroyed"
  end
end

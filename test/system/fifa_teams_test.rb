require "application_system_test_case"

class FifaTeamsTest < ApplicationSystemTestCase
  setup do
    @fifa_team = fifa_teams(:one)
  end

  test "visiting the index" do
    visit fifa_teams_url
    assert_selector "h1", text: "Fifa Teams"
  end

  test "creating a Fifa team" do
    visit fifa_teams_url
    click_on "New Fifa Team"

    fill_in "Career", with: @fifa_team.career
    fill_in "Name", with: @fifa_team.name
    fill_in "Stars", with: @fifa_team.stars
    click_on "Create Fifa team"

    assert_text "Fifa team was successfully created"
    click_on "Back"
  end

  test "updating a Fifa team" do
    visit fifa_teams_url
    click_on "Edit", match: :first

    fill_in "Career", with: @fifa_team.career
    fill_in "Name", with: @fifa_team.name
    fill_in "Stars", with: @fifa_team.stars
    click_on "Update Fifa team"

    assert_text "Fifa team was successfully updated"
    click_on "Back"
  end

  test "destroying a Fifa team" do
    visit fifa_teams_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Fifa team was successfully destroyed"
  end
end

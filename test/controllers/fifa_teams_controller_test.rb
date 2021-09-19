require "test_helper"

class FifaTeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fifa_team = fifa_teams(:one)
  end

  test "should get index" do
    get fifa_teams_url
    assert_response :success
  end

  test "should get new" do
    get new_fifa_team_url
    assert_response :success
  end

  test "should create fifa_team" do
    assert_difference('FifaTeam.count') do
      post fifa_teams_url, params: { fifa_team: { career: @fifa_team.career, name: @fifa_team.name, stars: @fifa_team.stars } }
    end

    assert_redirected_to fifa_team_url(FifaTeam.last)
  end

  test "should show fifa_team" do
    get fifa_team_url(@fifa_team)
    assert_response :success
  end

  test "should get edit" do
    get edit_fifa_team_url(@fifa_team)
    assert_response :success
  end

  test "should update fifa_team" do
    patch fifa_team_url(@fifa_team), params: { fifa_team: { career: @fifa_team.career, name: @fifa_team.name, stars: @fifa_team.stars } }
    assert_redirected_to fifa_team_url(@fifa_team)
  end

  test "should destroy fifa_team" do
    assert_difference('FifaTeam.count', -1) do
      delete fifa_team_url(@fifa_team)
    end

    assert_redirected_to fifa_teams_url
  end
end

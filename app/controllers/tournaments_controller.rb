class TournamentsController < ApplicationController

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    if @tournament.save
      redirect_to new_tournament_team_path(@tournament.id)
    else
      flash.now[:danger] = "Failed to create a tournament"
      render 'new'
    end
  end

  def show
    @tournament = Tournament.find(params[:id])
    games_query = <<~QUERY
                    SELECT
                      Games.id,
                      Games.home_team_score,
                      Games.away_team_score,
                      Games.round,
                      h_t.name AS home_team,
                      a_t.name AS away_team,
                      h_f_t.name AS home_fifa_team,
                      a_f_t.name AS away_fifa_team,
                      h_f_t.img AS home_fifa_team_img,
                      a_f_t.img AS away_fifa_team_img
                    FROM Games
                      LEFT JOIN teams AS h_t ON Games.home_team_id = h_t.id
                      LEFT JOIN teams AS a_t ON Games.away_team_id = a_t.id
                      LEFT JOIN fifa_teams AS h_f_t ON Games.home_fifa_team_id::bigint = h_f_t.id
                      LEFT JOIN fifa_teams AS a_f_t ON Games.away_fifa_team_id::bigint = a_f_t.id
                    WHERE
                      Games.tournament_id = #{params[:id]}
                  QUERY

    result_query = <<~QUERY
                  SELECT
                    teams.name,
                    COUNT(CASE WHEN games.home_team_score IS NOT NULL AND games.away_team_score IS NOT NULL THEN 1 END) AS played_games,
                    SUM(CASE WHEN teams.id = games.home_team_id AND games.home_team_score IS NOT NULL THEN games.home_team_score ELSE 0 END) + SUM(CASE WHEN teams.id = games.away_team_id AND games.away_team_score IS NOT NULL THEN games.away_team_score ELSE 0 END) AS scored_goals,
                    SUM(CASE WHEN teams.id = games.home_team_id AND games.home_team_score IS NOT NULL THEN games.away_team_score ELSE 0 END) + SUM(CASE WHEN teams.id = games.away_team_id AND games.away_team_score IS NOT NULL THEN games.home_team_score ELSE 0 END) AS conceded_goals,
                    SUM(CASE WHEN teams.id = games.home_team_id AND games.home_team_score IS NOT NULL THEN games.home_team_score ELSE 0 END) + SUM(CASE WHEN teams.id = games.away_team_id AND games.away_team_score IS NOT NULL THEN games.away_team_score ELSE 0 END) - SUM(CASE WHEN teams.id = games.home_team_id AND games.home_team_score IS NOT NULL THEN games.away_team_score ELSE 0 END) - SUM(CASE WHEN teams.id = games.away_team_id AND games.away_team_score IS NOT NULL THEN games.home_team_score ELSE 0 END) AS goal_difference,
                    SUM(CASE WHEN teams.id = games.home_team_id AND games.home_team_score > games.away_team_score THEN 1 ELSE 0 END) + SUM(CASE WHEN teams.id = games.away_team_id AND games.home_team_score < games.away_team_score THEN 1 ELSE 0 END) AS wins,
                    SUM(CASE WHEN teams.id = games.home_team_id AND games.home_team_score = games.away_team_score THEN 1 ELSE 0 END) + SUM(CASE WHEN teams.id = games.away_team_id AND games.home_team_score = games.away_team_score THEN 1 ELSE 0 END) AS draws,
                    SUM(CASE WHEN teams.id = games.home_team_id AND games.home_team_score < games.away_team_score THEN 1 ELSE 0 END) + SUM(CASE WHEN teams.id = games.away_team_id AND games.home_team_score > games.away_team_score THEN 1 ELSE 0 END) AS losses,
                    (3 * (SUM(CASE WHEN teams.id = games.home_team_id AND games.home_team_score > games.away_team_score THEN 1 ELSE 0 END) + SUM(CASE WHEN teams.id = games.away_team_id AND games.home_team_score < games.away_team_score THEN 1 ELSE 0 END))) + SUM(CASE WHEN teams.id = games.home_team_id AND games.home_team_score = games.away_team_score THEN 1 ELSE 0 END) + SUM(CASE WHEN teams.id = games.away_team_id AND games.home_team_score = games.away_team_score THEN 1 ELSE 0 END) AS points
                  FROM
                    teams
                  LEFT JOIN
                    games
                  ON
                    teams.id = games.home_team_id OR teams.id = games.away_team_id
                  WHERE
                    teams.tournament_id = #{params[:id]}
                  GROUP BY
                    teams.name
                QUERY

    @games = ActiveRecord::Base.connection.execute(games_query)
    @result = ActiveRecord::Base.connection.execute(result_query).sort_by { |hsh| [hsh["points"], hsh["goal_difference"], hsh["scored_goals"]] }.reverse
  end

  def index
    @tournaments = Tournament.where("name LIKE ?", "%#{params[:search]}%").reverse
    @search = params[:search]
  end

  private

    def tournament_params
      params.require(:tournament).permit(:name, :pin)
    end
end

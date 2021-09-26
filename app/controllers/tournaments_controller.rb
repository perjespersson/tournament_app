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
    games = Game.where(tournament_id: params[:id])
    @games = games.paginate(page: params[:page], per_page: games.where(round: "1").count)

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

    @result = ActiveRecord::Base.connection.execute(result_query).sort_by { |hsh| [hsh["points"], hsh["goal_difference"], hsh["scored_goals"]] }.reverse
  end

  def index
    @tournaments = Tournament.where("name LIKE ?", "%#{params[:search]}%").reverse.paginate(page: params[:page], per_page: 5)
    @search = params[:search]
  end

  private

    def tournament_params
      params.require(:tournament).permit(:name, :pin)
    end
end

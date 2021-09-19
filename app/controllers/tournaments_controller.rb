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
    games_query = "SELECT Games.id, Games.home_team_score, Games.away_team_score, Games.round,
                   h_t.name AS home_team,
                   a_t.name AS away_team,
                   h_f_t.name AS home_fifa_team,
                   a_f_t.name AS away_fifa_team,
                   h_f_t.img AS home_fifa_team_img,
                   a_f_t.img AS away_fifa_team_img
                   FROM Games
                   LEFT JOIN teams AS h_t ON Games.home_team_id = h_t.id
                   LEFT JOIN teams AS a_t ON Games.away_team_id = a_t.id
                   LEFT JOIN fifa_teams AS h_f_t ON Games.home_fifa_team_id = h_f_t.id
                   LEFT JOIN fifa_teams AS a_f_t ON Games.away_fifa_team_id = a_f_t.id
                   WHERE Games.tournament_id = #{params[:id]}"

    table_result = Team.where(tournament_id: params[:id]).as_json

    (0...table_result.length()).each do |i|

      table_result[i][:wins] = 0
      table_result[i][:draws] = 0
      table_result[i][:losses] = 0
      table_result[i][:played_games] = 0

      home_games = Game.where(home_team_id: table_result[i]["id"])
      away_games = Game.where(away_team_id: table_result[i]["id"])

      (0...home_games.length()).each do |j|
        unless home_games[j].home_team_score.nil? && home_games[j].home_team_score.nil?
          if home_games[j].home_team_score > home_games[j].away_team_score
            table_result[i][:wins] = table_result[i][:wins] + 1
          elsif home_games[j].home_team_score == home_games[j].away_team_score
            table_result[i][:draws] = table_result[i][:draws] + 1
          else
            table_result[i][:losses] = table_result[i][:losses] + 1
          end

          table_result[i][:played_games] = table_result[i][:played_games] + 1
        end
      end

      (0...away_games.length()).each do |j|
        unless away_games[j].home_team_score.nil? && away_games[j].home_team_score.nil?
          if away_games[j].away_team_score > away_games[j].home_team_score
            table_result[i][:wins] = table_result[i][:wins] + 1
          elsif away_games[j].away_team_score == away_games[j].home_team_score
            table_result[i][:draws] = table_result[i][:draws] + 1
          else
            table_result[i][:losses] = table_result[i][:losses] + 1
          end

          table_result[i][:played_games] = table_result[i][:played_games] + 1
        end
      end

      table_result[i][:scored_goals] = home_games.sum(:home_team_score) + away_games.sum(:away_team_score)
      table_result[i][:conceded_goals] = home_games.sum(:away_team_score) + away_games.sum(:home_team_score)
      table_result[i][:goal_difference] = table_result[i][:scored_goals] - table_result[i][:conceded_goals]
      table_result[i][:points] = (table_result[i][:wins] * 3) + table_result[i][:draws]
    end

    @games = ActiveRecord::Base.connection.execute(games_query).paginate(page: params[:page], per_page: (table_result.length().to_f/2).floor(0))
    @result = table_result.sort_by { |hsh| [hsh[:points], hsh[:goal_difference], hsh[:scored_goals]] }.reverse
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

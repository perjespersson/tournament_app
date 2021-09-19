class GamesController < ApplicationController
  def create

    #Check that teams are atleast 2
    teams_count = Team.where(tournament_id: params[:tournament_id]).count(:id)

    if teams_count < 2
      flash[:danger] = "You must have atleast 2 teams"
      redirect_to new_tournament_team_path(params[:tournament_id])
    elsif number_of_rounds < 1
      flash[:danger] = "You must choose how many rounds"
      redirect_to new_tournament_team_path(params[:tournament_id])
    else
      games = generate_games
      puts"--------"
      puts games
      puts"--------"
      Game.create(games)
      tournament = Tournament.find(params[:tournament_id])
      tournament.update(tournament_created: true)
      session[:tournament_id] = tournament.id
      redirect_to tournament_path(params[:tournament_id])
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if @game.update(game_params)
      redirect_to tournament_path(params[:tournament_id]) + '?page=' + @game.round
    else

    end
  end


  private

  def game_params
    params.require(:game).permit(:home_team_score, :away_team_score, :tournament_id)
  end

  def number_of_rounds
    params.require(:games).permit(:number_of_rounds)["number_of_rounds"].to_i
  end

  def generate_games
    @teams = Team.where(tournament_id: params[:tournament_id]).pluck(:id)
    fifa_teams = FifaTeam.pluck(:id)

    @teams.push(nil) if @teams.size.odd?
    @rounds = []
    rounds = (@teams.size - 1) * number_of_rounds

    matches_per_round = @teams.size / 2
    game_round = 1

    rounds.times do |index|

      matches_per_round.times do |match_index|
        home_fifa_team = rand(1..fifa_teams.length)
        away_fifa_team = home_fifa_team

        while home_fifa_team == away_fifa_team do
          home_fifa_team = rand(1..fifa_teams.length)
        end

        @rounds.push({round: game_round, tournament_id: params[:tournament_id].to_i, home_team_score: nil, away_team_score: nil, home_team_id: @teams[match_index], away_team_id: @teams.reverse[match_index], home_fifa_team_id: fifa_teams[home_fifa_team], away_fifa_team_id: fifa_teams[away_fifa_team] })
      end
      @teams = [@teams[0]] + @teams[1..-1].rotate(-1)
      game_round = game_round + 1
    end

    return @rounds
  end
end

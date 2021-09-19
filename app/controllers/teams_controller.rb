class TeamsController < ApplicationController

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @teams = Team.where(tournament_id: params[:tournament_id])
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to new_tournament_team_path(@team.tournament_id)
    else
      flash.now[:danger] = "Failed to create team"
      render 'new'
    end
  end

  def destroy
    Team.find(params[:id]).destroy
    flash[:success] = "Team deleted"
    redirect_to new_tournament_team_path(params[:tournament_id])
  end

  private

    def team_params
      params.require(:team).permit(:name, :tournament_id)
    end
end

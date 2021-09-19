class FifaTeamsController < ApplicationController
  before_action :set_fifa_team, only: %i[ show edit update destroy ]

  # GET /fifa_teams or /fifa_teams.json
  def index
    @fifa_teams = FifaTeam.all
  end

  # GET /fifa_teams/1 or /fifa_teams/1.json
  def show
  end

  # GET /fifa_teams/new
  def new
    @fifa_team = FifaTeam.new
  end

  # GET /fifa_teams/1/edit
  def edit
  end

  # POST /fifa_teams or /fifa_teams.json
  def create
    @fifa_team = FifaTeam.new(fifa_team_params)

    respond_to do |format|
      if @fifa_team.save
        format.html { redirect_to @fifa_team, notice: "Fifa team was successfully created." }
        format.json { render :show, status: :created, location: @fifa_team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fifa_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fifa_teams/1 or /fifa_teams/1.json
  def update
    respond_to do |format|
      if @fifa_team.update(fifa_team_params)
        format.html { redirect_to @fifa_team, notice: "Fifa team was successfully updated." }
        format.json { render :show, status: :ok, location: @fifa_team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fifa_team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fifa_teams/1 or /fifa_teams/1.json
  def destroy
    @fifa_team.destroy
    respond_to do |format|
      format.html { redirect_to fifa_teams_url, notice: "Fifa team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fifa_team
      @fifa_team = FifaTeam.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fifa_team_params
      params.require(:fifa_team).permit(:name, :stars, :career)
    end
end

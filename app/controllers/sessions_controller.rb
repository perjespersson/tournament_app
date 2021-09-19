class SessionsController < ApplicationController

  def create

    tournament = Tournament.find_by(id: params[:session][:id])

    if (tournament.pin.to_s == params[:session][:pin])
      session[:tournament_id] = tournament.id
      redirect_to tournament_path(params[:session][:id])
    else
      #print error message
      session.delete(:tournament_id)
      flash[:danger] = 'Fel pin'
      redirect_to tournament_path(params[:session][:id])
    end
  end
end

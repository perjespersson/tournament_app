module SessionsHelper
  def tournament_authenticated?
    session[:tournament_id].to_s == params[:id].to_s
  end
end

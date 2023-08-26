class ApplicationController < ActionController::Base

  helper_method :current_user

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end


  def ensure_user
    if current_user.nil?
      redirect_to sing_in_path
    end
  end

end

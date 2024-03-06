class ApplicationController < ActionController::API
    before_action :authenticate_game_center_user
    protected

    def authenticate_game_center_user

      jwt = begin request.headers['Authorization'] rescue nil end
      @current_user = User.find_by(jwt: jwt)
      
      if @current_user.nil?
        render json: {}, status: 401
      end
    end
  end
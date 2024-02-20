class ApplicationController < ActionController::API
    before_action :authenticate_game_center_user
    protected

    def authenticate_game_center_user
      jwt = begin JSON.parse(request.headers['Authorization'])['jwt'] rescue nil end
      @current_user = User.find_by(jwt: jwt)
      
      if @current_user.nil?
        render json: {}, status: 401
      end
    end
  end
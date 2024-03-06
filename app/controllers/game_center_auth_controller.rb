class GameCenterAuthController < ApplicationController
    skip_before_action :authenticate_game_center_user
    def authenticate
      game_center_id = params[:game_center_id]
      if request.server_name == ENV['GAME_CENTER_SERVER']
        @user =  User.find_by(:username => params[:displayName])
        if @user.nil?
          # If the user doesn't exist, create a new user
          
          @user = User.create(username: params[:displayName])
          @user.save
        end

        generate_auth_token(@user)
    
        
        render json: { jwt: @user.jwt }
      else
        puts request.server_name 
        render json: {}, status: 401
      end
    end
  
    private
  
    def generate_auth_token(user)
      # Your logic to generate authentication token (e.g., JWT)
      user.jwt = SecureRandom.hex
      user.save
    end
  end
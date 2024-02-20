class GameCenterAuthController < ApplicationController
    skip_before_action :authenticate_game_center_user
    def authenticate
      game_center_id = params[:game_center_id]
      if request.server_name == ENV['GAME_CENTER_SERVER']
        if ENV['RAILS_ENV'] == 'development'
            @user =  User.find_by(:username => params[:username])
        else
            @user =  User.find_by(:apple_game_center_id => params[:game_center_id])
        end
      
        if @user.nil?
          # If the user doesn't exist, create a new user
          @user = User.create(apple_game_center_id: game_center_id)
          @user.username = params[:username]
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
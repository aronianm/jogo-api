class UsersController < ApplicationController

    def check_user
        removed_code = params[:phone_number].gsub("+1", "")
       
        user = User.find_by_phone removed_code
        render :json => {
            user_found: !user.nil?,
            user_id: user.try(:id)
            
        }
    end

    def primary_user
        render :json => @current_user
    end
end

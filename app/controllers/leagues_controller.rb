class LeaguesController < ApplicationController
    def index
        leagues = League.includes(:user_leagues => :user).where('user_leagues.user_id' => current_user.id).as_json(
            include: {:user_leagues => {
                      include: :user}
    }
        )
    
        leagues.map do |l|
            l['userLeagues'] = l.delete('user_leagues')
        end
        
        render json: leagues
        
    end

    def create
        l = League.create(league_params)
        u = UserLeague.new(
            user_id: current_user.id,
            league_id: l.id
        )
        u.save
        
        render :json => UserLeague.includes(:league).as_json(include: {:league => {
            include: :season_matchups
        }})
    end

    def show
        binding.pry
    end


    private
    def league_params 
        params[:league].permit(:leagueName, :numberOfWeeks)
    end

end
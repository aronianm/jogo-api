class LeaguesController < ApplicationController
    def index
    
        league_ids = League.joins(:user_leagues).where('user_leagues.user_id' => @current_user.id).pluck(:id)
        leagues = League.includes(:user_leagues => :user).where(id: league_ids).as_json(
            include: {:user_leagues => {
                      include: :user}
        })
    
        leagues.map do |l|
            l['userLeagues'] = l.delete('user_leagues')
        end
        render json: leagues
        
    end

    def create
        
        l = League.create(league_params)
        u = UserLeague.new(
            user_id: @current_user.id,
            league_id: l.id
        )
        unless u.save
            l.delete
        end
        render :ok
    end

    def join
        l = League.find_by(:leagueCode => params[:league][:code])
        unless l.nil?
            u = UserLeague.new(
                user_id: @current_user.id,
                league_id: l.id
            )
            u.save
        end
        render :ok
    end

    def show
        render :json => League.find(params[:id])
    end

    def leave_league
        league = League.find(params[:id])
        UserLeague.where(:user_id => @current_user.id, :league_id => league.id).destroy_all
        if league.user_leagues.count == 0
            league.destroy
        end
        render :ok
    end


    private
    def league_params 
        params[:league].permit(:leagueName, :numberOfWeeks, :numberOfUsersNeeded)
    end

end
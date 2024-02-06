class SeasonsController < ApplicationController

    def show 
        s = Season.find_by(params[:id])
        season_object = s.as_json
        season_object['seasonMatchup'] = s.season_matchups.order('week desc').as_json(
            methods: [
                :id,
                :week,
                :season_id,
                :userTwoTotalScore,
                :userOneTotalScore,
                :userOneFormattedScore,
                :userTwoFormattedScore,
                :save
            ]
        )
        season_object['matchup']  =  s.matchup.as_json
        season_object['matchup']['currentUser'] = current_user.id
        if s
            render :json => season_object
        else
            render :json => 404
        end
    end
end

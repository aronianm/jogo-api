class UserLeague < ApplicationRecord
    belongs_to :league, class_name: 'League', :foreign_key => :league_id
    belongs_to :user, class_name: 'User', :foreign_key => :user_id
    
    before_create :set_wins_and_losses
    after_create :set_matchups


    private
    def set_wins_and_losses
        self.wins = 0
        self.losses = 0
    end

    def set_matchups
        users_in_league = league.user_leagues.length
        if users_in_league == league.numberOfUsersNeeded
            league.build_matchups
        end
    end


end
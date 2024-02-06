class Season < ApplicationRecord
    has_many :season_matchups, class_name: 'SeasonMatchup'
    belongs_to :matchup

    after_create :pre_build_season_matchups


    def max_week_matchup
        season_matchups.order(week: :desc).first
    end
    
    def build_new_week
        max_week = season_matchups.order(week: :desc).first.week
        SeasonMatchup.create(:season_id => self.id, week: max_week + 1)
    end
      
    private
    def pre_build_season_matchups
        SeasonMatchup.create(:season_id => self.id)
    end
end
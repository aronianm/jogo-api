class SeasonMatchup < ApplicationRecord
    belongs_to :season, class_name: 'Season', optional: true

    before_create :set_score_dates
    def userOneFormattedScore
        self.userOneDailyScore + self.userOneTotalScore
    end
    def userTwoFormattedScore
        self.userTwoDailyScore + self.userTwoTotalScore
    end
    private
    def set_score_dates
        today = Date.today
        self.userOneScoreUpdated = today + 1.day
        self.userTwoScoreUpdated = today + 1.day
        self.endDate = today + 7.day
    end
end
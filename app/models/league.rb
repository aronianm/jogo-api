class League < ApplicationRecord
    has_many :matchups, class_name: 'Matchup', primary_key: 'league_id'
    has_many :user_leagues, class_name: 'UserLeague', foreign_key: 'league_id'

    before_create :set_league_code




    private
    def set_league_code
        loop do
            code = SecureRandom.hex(3)
            self.leagueCode = code
            break unless League.exists?(leagueCode: code)
        end
    end
end
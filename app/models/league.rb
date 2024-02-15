class League < ApplicationRecord
    has_many :matchups, class_name: 'Matchup', foreign_key: 'league_id', dependent: :destroy
    has_many :user_leagues, class_name: 'UserLeague', foreign_key: 'league_id', dependent: :destroy

    before_create :set_league_code



    def build_matchups
        today = Date.today
        weeks = self.numberOfWeeks
        users = user_leagues.shuffle
        # Create matchups for each week
    
        weeks.times do |week|
            matchups = users.each_slice(2).to_a
            matchups.each do |(u1, u2)|
        
                # Determine the index of the matchup in the matchups array
                matchup_index = (week - 1) * matchups.length + matchups.index([u1, u2])
                
                # Determine the end date for the matchup (adjust as needed)
                end_date = Date.today + (7 * week).days
                
                # Create the matchup
                Matchup.create(league_id: self.id, 
                                userOneId: u1.user_id,
                                userTwoId: u2.user_id,
                                week: week + 1,
                                isActive: week == 0,
                                endDate: end_date)
            end
            users.shuffle!
        end
    end

    private
    def set_league_code
        loop do
            code = SecureRandom.hex(3)
            self.leagueCode = code
            break unless League.exists?(leagueCode: code)
        end
    end
end
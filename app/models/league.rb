class League < ApplicationRecord
    has_many :matchups, class_name: 'Matchup', foreign_key: 'league_id', dependent: :destroy
    has_many :user_leagues, class_name: 'UserLeague', foreign_key: 'league_id', dependent: :destroy

    before_create :set_league_code



    def build_matchups
        today = Date.today
        weeks = self.numberOfWeeks
        users = user_leagues.shuffle
        matchups = []
        # Generate matchups for each week
        weeks.times do |week|
            (users.length / 2).times do |i|
                user_one = users[i]
                user_two = users[-i - 1]
                # Check if user_one is not the same as user_two
                if user_one != user_two
                    matchups << [user_one, user_two, week + 1]
                end
            end
            users.rotate!
        end
        
        # Create matchups in the database
        matchups.each do |m|
            Matchup.create(league_id: self.id, 
                            userOneId: m[0].user_id,
                            userTwoId: m[1].user_id,
                            week: m[2],
                            isActive: m[2] == 1,
                            endDate: today + (7.days * m[2]))
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
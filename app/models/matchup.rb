class Matchup < ApplicationRecord
    belongs_to :userOne, class_name: 'User', foreign_key: 'userOneId'
    belongs_to :userTwo, class_name: 'User', foreign_key: 'userTwoId'
    belongs_to :league, class_name: 'League', foreign_key: 'league_id'
    before_create :massage_matchups
    before_update :updates_league_standings
    belongs_to :league, class_name: 'League', :foreign_key => :league_id


    has_many :user_leagues, through: :league

    def self.find_users user_id
        matchups = self.where("userTwo = :user_id", user_id: user_id)
        invitations_matchups = self.where("userOne = :user_id and userAccepted = true ", user_id: user_id)
        [matchups, invitations_matchups].flatten().compact
    end

    def self.find_users_invites user_id
        self.where("userOne = :user_id or userTwo = :user_id", user_id: user_id).where.not(
            createdBy: user_id).where(userAccepted: nil)
    end

    def opponent(current_user_id)
        opponent_user = user_one_id == current_user_id ? user_two : user_one
        opponent_user.as_json(only: [:id, :fname, :lname]) # Customize the attributes as needed
    end
    def opponentScore
        if self.viewing_user == self.userOne
            return self.userTwoDailyScore + self.userTwoTotalScore
        else
            return self.userOneDailyScore + self.userOneTotalScore
        end
    end
    def userScore
        if self.viewing_user == self.userOne
            return self.userOneDailyScore + self.userOneTotalScore
        else
            return self.userTwoDailyScore + self.userTwoTotalScore
        end
    end
    def activeSeason
        self.seasons.where(:active => true).first
    end

    def active?
        self.isActive && !self.userAccepted.nil?
    end

    def next_matchup currentWeek
        matchup = self.league.matchups.where(:week => currentWeek + 1)
        matchup.isActive = true
        matchup.save
        return matchup
    end

    private

    def unique_matchup
        # # Check if there's already a matchup with the same combination of userOne, userTwo, and isActive
        # existing_matchup = Matchup.find_by(userOne: userOne, userTwo: userTwo, isActive: true, week: week)
        
        # # If an existing matchup is found and it's not the current record
        # if existing_matchup && existing_matchup != self
        #   errors.add(:base, "This matchup combination already exists")
        # end
        
        # # If the combination of userOne and userTwo is the same as another record, but flipped
        # if Matchup.exists?(userOne: userTwo, userTwo: userOne, isActive: true)
        #   errors.add(:base, "The combination of userOne and userTwo already exists with flipped values")
        # end
        return true
    end

    def massage_matchups
        self.userOneDailyScore = 0
        self.userOneTotalScore = 0
        self.userTwoDailyScore = 0
        self.userTwoTotalScore = 0
        self.userOneScoreUpdated = Date.today
        self.userTwoScoreUpdated = Date.today
    end

    def updates_league_standings
        if self.isActive_changed? && self.isActive == false
            userOne = self.userOneId
            userOneScore = userOneDailyScore + userOneTotalScore
            userTwo = self.userTwoId
            userTwoScore = userTwoDailyScore + userTwoTotalScore
            if userOneScore > userTwoScore
                winner = userOne
                loser = userTwo
            else
                winner = userTwo
                loser = userOne
            end
            user_league_winner = UserLeague.find_by(user_id: winner, league_id: self.league_id)
            user_league_loser = UserLeague.find_by(user_id: loser, league_id: self.league_id)
            user_league_winner.update_attribute(:wins, user_league_winner.wins + 1)
            user_league_loser.update_attribute(:losses, user_league_loser.losses + 1)
        end
    end

end

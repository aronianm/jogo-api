class Matchup < ApplicationRecord

    has_many :seasons
    belongs_to :userOne, class_name: 'User', foreign_key: 'userOne'
    belongs_to :userTwo, class_name: 'User', foreign_key: 'userTwo'
    before_update :build_seasons

    validate :unique_matchup
  

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

    private
    def build_seasons
        if self.userAccepted && self.userAccepted_changed?
            season = Season.create(:matchup_id => self.id)
            season.save
        end
    end

    def unique_matchup
        # Check if there's already a matchup with the same combination of userOne, userTwo, and isActive
        existing_matchup = Matchup.find_by(userOne: userOne, userTwo: userTwo, isActive: true)
        
        # If an existing matchup is found and it's not the current record
        if existing_matchup && existing_matchup != self
          errors.add(:base, "This matchup combination already exists")
        end
        
        # If the combination of userOne and userTwo is the same as another record, but flipped
        if Matchup.exists?(userOne: userTwo, userTwo: userOne, isActive: true)
          errors.add(:base, "The combination of userOne and userTwo already exists with flipped values")
        end
    end

end

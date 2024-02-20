class User < ApplicationRecord
  #  has_encrypted :game_center_id

    def name
      "#{self.fname} #{self.lname}"
    end

end

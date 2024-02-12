class UserLeague < ApplicationRecord
    belongs_to :league, class_name: 'League', :foreign_key => :id
    belongs_to :user, class_name: 'User', :foreign_key => :id
    
end
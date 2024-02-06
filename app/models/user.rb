class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :phone_number, presence: true, uniqueness: true


    def name
      "#{self.fname} #{self.lname}"
    end

    # Add :phone_number to authentication_keys
    def self.authentication_keys
      [:phone_number]
    end

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      phone_number = conditions.delete(:phone_number)
      where(conditions.to_hash).where(["phone_number = :value", { value: phone_number }]).first
    end

    def email_required?
      false
    end

    def self.find_by_phone phone_number
      phonelib = Phonelib.parse(phone_number)
      number = phonelib.national_number.gsub(/(\d{3})(\d{3})(\d{4})/, '\1-\2-\3')
      self.find_by phone_number: number
    end
end

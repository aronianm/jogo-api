# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   [Action, Comedy, Drama, Horror].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



# create users 
def user_params **kwargs 
    data = {
    fname: "",
    lname: "",
    email: "",
    phone_number: "",
    encrypted_password: "",
    reset_password_token: "",
    reset_password_sent_at: "",
    remember_created_at: "",
    sign_in_count: "",
    current_sign_in_at: "",
    last_sign_in_at: "",
    current_sign_in_ip: "",
    last_sign_in_ip: "",
    confirmation_token: "",
    confirmed_at: "",
    confirmation_sent_at: "",
    unconfirmed_email: "",
    failed_attempts: "",
    unlock_token: "",
    locked_at: "",
    created_at: "",
    updated_at: "",
    jti: ""} 
    data.merge!(kwargs)
end

def matchup_params **kwargs
    data = {
     user1: "", 
     user2: "", 
     user1_score: "", 
     user2_score: "", 
     is_active: ""} 
     data.merge!(kwargs)
end

creation_users = [
    {fname: "Tony", lname: "Harrison", phone_number: "978-726-5883", password: "looser67"},
    {fname: "Lenny", lname: "Parker", phone_number: "978-726-5884", password: "looser67"},
    {fname: "Jennifer", lname: "Aronian", phone_number: "774-573-5663", password: "looser67"},
]

users = {}

creation_users.each.with_index do |u, i|
    user_param = user_params **u
    unless User.find_by(phone_number: user_param[:phone_number])
        puts "Creating #{user_param}"
        User.create!(u)
    end
end

User.all.each.with_index do |u, i|
    users[i] = u.id
end

# matchups = [
#     {user1: users[0], user2: users[1]}
# ]

# matchups.each.with_index do |matchup, i|
#     matchup_param = matchup_params **matchup
#     unless Matchup.find_by(user1: matchup_param[:user1], user2:matchup_param[:user2])
#         puts "matchup #{matchup_param}"
#         Matchup.create!(matchup_param)
#     end
# end




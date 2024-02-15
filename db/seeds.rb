# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   [Action, Comedy, Drama, Horror].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



l = League.create(leagueName: "Test League 20", numberOfWeeks: 10, numberOfUsersNeeded: 20)
users = []
# 19.times do |i|
#     u = User.create(fname: "Test#{i}", lname: "User#{i}", phone_number: "123-456-7#{i + 10}", email: "test#{i}@gmail.com", password: "password")
#     users.push(u)
# end

users = User.all.take(20)

users.each do |u|
    UserLeague.create(user_id: u.id, league_id: l.id)
end

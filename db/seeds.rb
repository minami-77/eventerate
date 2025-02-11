# # This file should ensure the existence of records required to run the application in every environment (production,
# # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Example:
# #
# #   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
# #     MovieGenre.find_or_create_by!(name: genre_name)
# #   end
# number_of_organizations = 5
# number_of_users = 50
# number_of_events = 5
# number_of_activities = 5

# Event.destroy_all
# Activity.destroy_all
# Task.destroy_all
# TasksUser.destroy_all
# Collaborator.destroy_all
# OrganizationUser.destroy_all
# Organization.destroy_all
# User.destroy_all
# puts "Old data removed!"

# puts "Creating Team"
# team = Organization.create!(name: "Eventerate Team")
# puts "Team Organization created"
# eventerate = []
# eventerate << User.create!(email: "cindy@cindy.com", first_name: "Cindy", last_name: "Team", password: "123456")
# eventerate << User.create!(email: "Minami@Minami.com", first_name: "Minami", last_name: "Team", password: "123456")
# eventerate << User.create!(email: "alex@alex.com", first_name: "Alex", last_name: "Team", password: "123456")
# eventerate << User.create!(email: "allan@allan.com", first_name: "Allan", last_name: "Team", password: "123456")
# puts "Team users created!"
# eventerate.each do |user|
#   OrganizationUser.create!(
#     user: user,
#     organization: team,
#     role: "manager"
# )
# end

# event_types = ["Christmas", "Halloween", "Easter", "Sports Day"]
# event_dates = ['2025-12-25', '2025-10-31', '2025-04-01', '2025-09-01']
# eventerate.each_with_index do |user, index|
#   Event.create!(
#     title: event_types[index],
#     date: event_dates[index],
#     duration: 120,
#     organization: team,
#     user: user
#   )
# end

# puts "Events created!"
# puts "Adding users to events"

# activites = ["cooking", "crafts", "singing", "games"]
# tasks = ["buy materials", "set up room", "run activity", "clean up"]
# Event.all.each do |event|
#   eventerate.each do |user|
#     Collaborator.create!(user: user, event: event)
#   end

#   activites.each_with_index do |activity, index|
#     new_activity = Activity.create!(title: activity, event: event)

#     tasks.each do |task|
#       new_task = Task.create!(
#         title: task,
#         completed: false,
#         activity: new_activity,
#         comment: 'comments'
#       )
#       TasksUser.create!(
#         task: new_task,
#         user: eventerate[index]
#       )
#     end
#   end
# end
# puts "Finished adding eventerate users..."
# puts "Adding additional data"



# puts "Creating organizations..."
# organizations = []
# number_of_organizations.times do |org|
#   organizations << Organization.create!(
#     name: Faker::Company.name,
#   )
# end
# puts "Organizations created!"

# puts "Creating users..."
# users = []
# number_of_users.times do |user|
#   users << User.create!(
#     email: Faker::Internet.email,
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     password: "123456",
#   )
# end
# puts "Users created!"

# puts "Add Users to Organizations..."

# users.each do |user|
#   selected_organizations = organizations.sample(rand(1..3))
#   selected_organizations.each do |organization|
#     OrganizationUser.create!(
#       user: user,
#       organization: organization,
#       role: 'user'
#     )
#   end
# end

# puts "Users added to Organizations!"

# puts "Adding Managers to Organizations..."
# organizations.each do |organization|
#   OrganizationUser.create!(
#     user: User.create!(
#       email: Faker::Internet.email,
#       first_name: Faker::Name.first_name,
#       last_name: Faker::Name.last_name,
#       password: "123456"),
#     organization: organization,
#     role: 'manager'
#   )
# end
# puts "Added Managers to Organizations!"

# puts "Creating Events..."
# durations = [90, 120, 30, 60]
# event_types = ["Christmas", "Halloween", "Easter", "Sports Day", "Graduation"]
# organizations.each do |organization|
#   number_of_events.times do |event|
#     Event.create!(
#       title: event_types.sample,
#       date: Faker::Date.between(from: '2025-01-01', to: '2025-12-31'),
#       duration: durations.sample,
#       organization: organization,
#       user: organization.users.sample
#     )
#   end
# end

# puts "Events created!"

# puts "Adding Collaborators, activites, and tasks to events"

# activites = ["cooking", "playing", "watching", "singing", "arts", "crafts"]
# Event.all.each do |event|
#   event.organization.users.each do |user|
#     Collaborator.create!(user: user, event: event)
#   end

#   number_of_activities.times do |activity|
#     Activity.create!(
#       title: activites.sample,
#       event: event
#     )
#   end

#   event.activities.each do |activity|
#     Task.create!(
#       title: Faker::Lorem.word,
#       completed: false,
#       activity: activity,
#       comment: Faker::Lorem.sentence
#     )
#   end
# end

# puts "Collaborators, Activities and tasks added!"
# puts "Assigning Tasks to Users..."

# Task.all.each do |task|
#   TasksUser.create!(
#     task: task,
#     user: task.activity.event.organization.users.sample
#   )
# end

# puts "Tasks assigned to Users!"
# puts "Seeding Complete!"

puts "Creating an activities"

Activity.create!(title: "Christmas Caroling", genre: ["christmas"], description: "Groups of kids sing popular Christmas carols door-to-door or within the event space.

", duration: 10, age: 5, event_id: 1)

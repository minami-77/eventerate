
# number_of_organizations = 5
# number_of_users = 50
# number_of_events = 5
# number_of_activities = 5

# Event.destroy_all
# # Activity.destroy_all
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
# array_of_users = []
# array_of_users << User.create!(email: "cindy@cindy.com", first_name: "Cindy", last_name: "Team", password: "123456")
# array_of_users << User.create!(email: "Minami@Minami.com", first_name: "Minami", last_name: "Team", password: "123456")
# array_of_users << User.create!(email: "alex@alex.com", first_name: "Alex", last_name: "Team", password: "123456")
# array_of_users << User.create!(email: "allan@allan.com", first_name: "Allan", last_name: "Team", password: "123456")
# puts "Team users created!"
# array_of_users.each do |user|
#   OrganizationUser.create!(
#     user: user,
#     organization: team,
#     role: "manager"
# )
# end

# event_types = ["Christmas", "Halloween", "Easter", "Sports Day"]
# event_dates = ['2025-12-25', '2025-10-31', '2025-04-01', '2025-09-01']
# array_of_users.each_with_index do |user, index|
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

# # activites = ["cooking", "crafts", "singing", "games"]
# tasks = ["buy materials", "set up room", "run activity", "clean up"]
# Event.all.each do |event|
#   array_of_users.each do |user|
#     Collaborator.create!(user: user, event: event)
#   end

#     tasks.each_with_index do |task, index|
#       new_task = Task.create!(
#         title: task,
#         completed: false,
#         event: event,
#         comment: 'comments'
#       )
#       TasksUser.create!(
#         task: new_task,
#         user: array_of_users[index % array_of_users.length]
#       )
#     end
#   end
# puts "Finished adding array_of_users users..."
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

# puts "Assigning Tasks to Users..."

# Task.all.each do |task|
#   TasksUser.create!(
#     task: task,
#     user: task.event.organization.users.sample
#   )
# end

# puts "Tasks assigned to Users!"
# puts "Seeding Complete!"

# puts "Creating an activities"

# Activity.create!(title: "Christmas Caroling", genre: ["christmas"], description: "Groups of kids sing popular Christmas carols door-to-door or within the event space.

# ", duration: 10, age: 5)

# Destroy existing data to start fresh
TasksUser.destroy_all
Task.destroy_all
Collaborator.destroy_all
Event.destroy_all
OrganizationUser.destroy_all
Organization.destroy_all
User.destroy_all
puts "Old data removed!"

# Create Eventerate Team Organization
puts "Creating Team"
team = Organization.create!(name: "Eventerate Team")
puts "Team Organization created"

# Create Team Users
array_of_users = []
array_of_users << User.create!(email: "cindy@cindy.com", first_name: "Cindy", last_name: "Team", password: "123456")
array_of_users << User.create!(email: "Minami@Minami.com", first_name: "Minami", last_name: "Team", password: "123456")
array_of_users << User.create!(email: "alex@alex.com", first_name: "Alex", last_name: "Team", password: "123456")
array_of_users << User.create!(email: "allan@allan.com", first_name: "Allan", last_name: "Team", password: "123456")
puts "Team users created!"

# Assign Users to Organization
array_of_users.each do |user|
  OrganizationUser.create!(user: user, organization: team, role: "manager")
end

# Create Events
puts "Creating Events"
event_types = ["Christmas", "Halloween", "Easter", "Sports Day"]
event_dates = ['2025-12-25', '2025-10-31', '2025-04-01', '2025-09-01']

events = []
array_of_users.each_with_index do |user, index|
  events << Event.create!(
    title: event_types[index],
    date: event_dates[index],
    duration: 120,
    organization: team,
    user: user
  )
end
puts "Events created!"

# Add Collaborators and Tasks
puts "Adding users to events and assigning tasks"
tasks = ["buy materials", "set up room", "run activity", "clean up"]

events.each do |event|
  array_of_users.each do |user|
    Collaborator.create!(user: user, event: event)
  end

  tasks.each do |task_title|
    new_task = Task.create!(title: task_title, completed: false, event: event, comment: 'comments')
    TasksUser.create!(task: new_task, user: array_of_users.sample)
  end
end
puts "Finished adding users and tasks!"

# Additional Organizations and Users
puts "Creating additional organizations and users..."
organizations = []
5.times { organizations << Organization.create!(name: Faker::Company.name) }

users = []
50.times { users << User.create!(email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, password: "123456") }
puts "Users and Organizations created!"

# Assign Users to Organizations
users.each do |user|
  organizations.sample(rand(1..3)).each do |organization|
    OrganizationUser.create!(user: user, organization: organization, role: 'user')
  end
end
puts "Users assigned to organizations!"

# Assign Managers to Organizations
organizations.each do |organization|
  OrganizationUser.create!(
    user: User.create!(email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, password: "123456"),
    organization: organization,
    role: 'manager'
  )
end
puts "Managers assigned!"

# Create Activities
puts "Creating an activity"
Activity.create!(
  title: "Christmas Caroling",
  genre: ["christmas"],
  description: "Groups of kids sing popular Christmas carols door-to-door or within the event space.",
  duration: 10,
  age: 5
)
puts "Activity created!"

puts "Seeding Complete!"

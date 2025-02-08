# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
number_of_organizations = 5
number_of_users = 50
number_of_events = 5
number_of_activities = 5

puts "Removing old data..."
User.destroy_all
Organization.destroy_all
Collaborator.destroy_all
Event.destroy_all
Activity.destroy_all
TasksUser.destroy_all
Task.destroy_all
OrganizationsUser.destroy_all
puts "Old data removed!"


puts "Creating organizations..."
organizations = []
number_of_organizations.times do |org|
  organizations << Organization.create!(
    name: Faker::Company.name,
  )
end
puts "Organizations created!"

puts "Creating users..."
users = []
number_of_users.times do |user|
  users << User.create!(
    email: Faker::Internet.email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    password: "123456",
  )
end
puts "Users created!"

puts "Add Users to Organizations..."

user.each do |user|
  selected_organizations = organizations.sample(rand(1..3))
  selected_organizations.each do |organization|
    OrganizationsUser.create!(
      user: user,
      organization: organization,
      role: 'user'
    )
  end
end

puts "Users added to Organizations!"

puts "Adding Managers to Organizations..."
organizations.each do |organization|
  OrganizationsUsers.create!(
    user: User.create!(
      email: Faker::Internet.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      password: "123456"),
    organization: organization,
    role: 'manager'
  )
end
puts "Added Managers to Organizations!"

puts "Creating Events..."
durations = [90, 120, 30, 60]
event_types = ["Christmas", "Halloween", "Easter", "Sports Day", "Graduation"]
organizations.each do |organization|
  number_of_events.times do |event|
    Event.create!(
      title: event_types[i % event_types.length],
      date: Faker::Date.between(from: '2025-01-01', to: '2025-12-31'),
      duration: durations.sample,
      organization: organization
    )
  end
end

puts "Events created!"

puts "Adding Collaborators, activites, and tasks to events"

activites = ["cooking", "playing", "watching", "singing", "arts", "crafts"]
Event.all.each do |event|
  event.organization.users.each do |user|
    Collaborators.create!(user: user, event: event)
  end

  number_of_activities.times do |activity|
    Activity.create!(
      title: activites[i % activites.length],
      event: event
    )
  end

  event.activities.each do |activity|
    TasksUser.create!(
      title: Faker::Lorem.word,
      completed: false,
      activity: activity,
      comment: Faker::Lorem.sentence
    )
  end
end

puts "Collaborators, Activities and tasks added!"
puts "Assigning Tasks to Users..."

Task.all.each do |task|
  TasksUser.create!(
    task: task,
    user: task.activity.event.organization.users.sample
  )
end

puts "Tasks assigned to Users!"
puts "Seeding Complete!"

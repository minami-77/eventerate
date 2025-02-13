
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

# Activity.create!(title: "Christmas Caroling", genres: ["christmas"], description: "Groups of kids sing popular Christmas carols door-to-door or within the event space.

# ", duration: 10, age: 5)

# Destroy existing data to start fresh
Activity.destroy_all
TasksUser.destroy_all
Task.destroy_all
Collaborator.destroy_all
Event.destroy_all
Invite.destroy_all
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
# puts "Creating an activity"
# Activity.create!(
#   title: "Christmas Caroling",
#   genres: ["christmas"],
#   description: "Groups of kids sing popular Christmas carols door-to-door or within the event space.",
#   duration: 10,
#   age: 5
# )
# puts "Activity created!"
puts "Seeding activities..."

activities = [
  # Christmas Genre
  { title: "Christmas Puzzle", genres: ["Christmas", "Others"], description: "Complete a fun Christmas-themed puzzle.", duration: 15, age: 4 },
  { title: "Gingerbread House Decoration", genres: ["Christmas", "Arts & Crafts"], description: "Decorate gingerbread houses with candies and frosting.", duration: 15, age: 4 },
  { title: "Christmas Gift Wrapping", genres: ["Christmas", "Arts & Crafts"], description: "Wrap Christmas gifts with colorful paper and ribbons.", duration: 15, age: 6 },
  { title: "Snowball Toss", genres: ["Christmas", "Sports"], description: "Toss fake snowballs into buckets or hoops for points.", duration: 15, age: 4 },
  { title: "Christmas Tree Scavenger Hunt", genres: ["Christmas", "Others"], description: "Search for hidden Christmas decorations around the house.", duration: 15, age: 4 },
  { title: "Christmas Card Making", genres: ["Christmas", "Arts & Crafts"], description: "Make personalized cards using various craft supplies.", duration: 15, age: 4 },
  { title: "DIY Christmas Ornaments", genres: ["Christmas", "Arts & Crafts"], description: "Create festive ornaments with materials like clay and paint.", duration: 15, age: 6 },
  { title: "Christmas Carol Sing-Along", genres: ["Christmas", "Singing"], description: "Sing along to popular Christmas songs.", duration: 15, age: 4 },
  { title: "Christmas Tree Decorating", genres: ["Christmas", "Arts & Crafts"], description: "Decorate a Christmas tree using handmade ornaments.", duration: 15, age: 6 },
  { title: "Christmas Bingo", genres: ["Christmas", "Others"], description: "Play a holiday-themed Bingo game.", duration: 15, age: 6 },

    # Halloween Genre
  { title: "Pumpkin Painting", genres: ["Halloween", "Arts & Crafts"], description: "Paint small pumpkins with fun designs.", duration: 15, age: 6 },
  { title: "Halloween Costume Contest", genres: ["Halloween", "Others"], description: "Dress up in costumes and participate in a friendly contest.", duration: 15, age: 6 },
  { title: "Spooky Scavenger Hunt", genres: ["Halloween", "Others"], description: "Search for spooky items in a fun hunt.", duration: 15, age: 6 },
  { title: "Mummy Relay Race", genres: ["Halloween", "Sports"], description: "Wrap teammates in toilet paper and race to finish first.", duration: 15, age: 6 },
  { title: "Halloween Charades", genres: ["Halloween", "Others"], description: "Act out Halloween-related words and phrases.", duration: 15, age: 6 },

  # Arts & Crafts Genre
  { title: "Origami Creations", genres: ["Arts & Crafts", "Others"], description: "Create paper sculptures using the art of origami.", duration: 15, age: 6 },
  { title: "Pom-Pom Making", genres: ["Arts & Crafts"], description: "Make colorful pom-poms for decoration or play.", duration: 15, age: 6 },
  { title: "Clay Sculpture", genres: ["Arts & Crafts"], description: "Mold and shape clay into small sculptures.", duration: 15, age: 4 },
  { title: "Paper Plate Masks", genres: ["Arts & Crafts"], description: "Design masks using paper plates and craft supplies.", duration: 15, age: 4 },
  { title: "Friendship Bracelets", genres: ["Arts & Crafts"], description: "Create bracelets using thread and beads for friends.", duration: 15, age: 8 },

  # Sports Genre
  { title: "Mini Obstacle Course", genres: ["Sports", "Others"], description: "Create an obstacle course and race through it.", duration: 15, age: 4 },
  { title: "Jump Rope Challenge", genres: ["Sports"], description: "Challenge friends to jump rope the most times.", duration: 15, age: 4 },
  { title: "Balloon Volleyball", genres: ["Sports"], description: "Play volleyball using a balloon as the ball.", duration: 15, age: 4 },
  { title: "Hula Hoop Contest", genres: ["Sports"], description: "See who can hula hoop the longest.", duration: 15, age: 4 },
  { title: "Ball Toss", genres: ["Sports"], description: "Toss a ball into a target to score points.", duration: 15, age: 4 },

  # Video Games Genre
  { title: "Dance Dance Revolution", genres: ["Video Games", "Dancing"], description: "Follow the dance moves on screen to score points.", duration: 15, age: 6 },
  { title: "Mario Kart Races", genres: ["Video Games", "Others"], description: "Race against friends in Mario Kart for fun.", duration: 15, age: 6 },
  { title: "Minecraft Creative Mode", genres: ["Video Games", "Others"], description: "Build and explore freely in Minecraft's creative mode.", duration: 15, age: 8 },
  { title: "Super Smash Bros. Tournament", genres: ["Video Games", "Others"], description: "Battle it out in a friendly Super Smash Bros. competition.", duration: 15, age: 6 },
  { title: "Puzzle Solving with Tetris", genres: ["Video Games", "Others"], description: "Play Tetris and compete for the best score.", duration: 15, age: 6 },

  # Dancing Genre
  { title: "Freeze Dance", genres: ["Dancing", "Others"], description: "Dance freely until the music stops, then freeze!", duration: 15, age: 4 },
  { title: "Hip-Hop Dance Routine", genres: ["Dancing"], description: "Learn a short hip-hop dance routine.", duration: 15, age: 8 },
  { title: "Line Dancing", genres: ["Dancing"], description: "Learn and perform simple line dances.", duration: 15, age: 6 },
  { title: "Ballet Basics", genres: ["Dancing"], description: "Practice basic ballet movements and poses.", duration: 15, age: 4 },
  { title: "Cha-Cha Challenge", genres: ["Dancing"], description: "Learn a quick Cha-Cha routine and challenge others.", duration: 15, age: 6 },

  # Singing Genre
  { title: "Karaoke Contest", genres: ["Singing", "Others"], description: "Sing your favorite songs in a karaoke contest.", duration: 15, age: 4 },
  { title: "Sing Along to Disney Songs", genres: ["Singing"], description: "Sing along to well-loved Disney classics.", duration: 15, age: 4 },
  { title: "Vocal Warm-Ups", genres: ["Singing", "Others"], description: "Practice vocal exercises to improve your singing voice.", duration: 15, age: 6 },
  { title: "Christmas Caroling", genres: ["Singing", "Christmas"], description: "Go caroling and spread holiday cheer.", duration: 15, age: 4 },
  { title: "Singing in the Rain", genres: ["Singing", "Dancing"], description: "Sing and dance to the classic tune 'Singing in the Rain.'", duration: 15, age: 4 },

  # Other Genre
  { title: "Origami for Beginners", genres: ["Others", "Arts & Crafts"], description: "Create simple origami animals and objects.", duration: 15, age: 6 },
  { title: "Simple Magic Tricks", genres: ["Others"], description: "Learn easy magic tricks to amaze your friends.", duration: 15, age: "6+" },
  { title: "DIY Slime", genres: ["Others", "Arts & Crafts"], description: "Make colorful and stretchy slime using simple ingredients.", duration: 15, age: 4 },
  { title: "Joke Contest", genres: ["Others"], description: "Share jokes and compete to make the group laugh the most.", duration: 15, age: 4 },
  { title: "Story Time", genres: ["Others"], description: "Listen to a short story and engage with the group afterward.", duration: 15, age: 4 },

  # More Activities
  { title: "Balloon Pop Trivia", genres: ["Others"], description: "Pop balloons to reveal trivia questions or challenges.", duration: 15, age: 4 },
  { title: "Puzzle Hunt", genres: ["Others"], description: "Search for scattered puzzle pieces and solve the puzzle together.", duration: 15, age: 6 },
  { title: "DIY Paper Airplanes", genres: ["Arts & Crafts", "Others"], description: "Make and decorate paper airplanes for a flying race.", duration: 15, age: 4 },
  { title: "Cup Stacking Challenge", genres: ["Sports", "Others"], description: "Stack plastic cups into pyramids as quickly as possible.", duration: 15, age: 4 },
  { title: "DIY Bird Feeders", genres: ["Arts & Crafts", "Others"], description: "Create simple bird feeders using everyday materials.", duration: 15, age: 4 },
  { title: "Pass the Parcel", genres: ["Others"], description: "Pass a gift around while music plays, revealing layers as you go.", duration: 15, age: 4 },
  { title: "Chalk Drawing Contest", genres: ["Arts & Crafts"], description: "Create fun sidewalk chalk art and see who has the most creativity.", duration: 15, age: 4 },
  { title: "Duct Tape Crafts", genres: ["Arts & Crafts"], description: "Use colorful duct tape to make wallets, keychains, or other items.", duration: 15, age: 8 },
  { title: "Memory Match Game", genres: ["Others"], description: "Play a memory game using cards or images.", duration: 15, age: 4 },
  { title: "Obstacle Relay Race", genres: ["Sports", "Others"], description: "Complete an obstacle course and race against time.", duration: 15, age: 4 },
  # Halloween Genre
  { title: "Witch's Brew Science Experiment", genres: ["Halloween", "Others"], description: "Create a fizzy potion using simple science experiments.", duration: 15, age: 6 },
  { title: "Halloween Pumpkin Hunt", genres: ["Halloween", "Others"], description: "Hide small pumpkins and go on a search to find them.", duration: 15, age: 4 },
  { title: "Zombie Tag", genres: ["Halloween", "Sports"], description: "Play tag, where the 'zombies' try to catch others.", duration: 15, age: 4 },
  { title: "Monster Drawing Contest", genres: ["Halloween", "Arts & Crafts"], description: "Draw spooky monsters and have others guess their names.", duration: 15, age: 4 },
  { title: "Candy Corn Relay Race", genres: ["Halloween", "Sports"], description: "Race while balancing candy corn or other small items.", duration: 15, age: 4 },

  # Arts & Crafts Genre
  { title: "DIY Dream Catchers", genres: ["Arts & Crafts"], description: "Create dream catchers using yarn, feathers, and beads.", duration: 15, age: 8 },
  { title: "DIY Photo Frames", genres: ["Arts & Crafts"], description: "Design and decorate your own picture frame.", duration: 15, age: 6 },
  { title: "Watercolor Painting", genres: ["Arts & Crafts"], description: "Paint beautiful watercolor designs on paper.", duration: 15, age: 6 },
  { title: "Rock Painting for Kindness", genres: ["Arts & Crafts"], description: "Paint rocks with positive messages to leave around the neighborhood.", duration: 15, age: 4 },
  { title: "Decorative Pillow Making", genres: ["Arts & Crafts"], description: "Create simple decorative pillows using fabric and thread.", duration: 15, age: 8 },

  # Sports Genre
  { title: "Mini Basketball Shootout", genres: ["Sports"], description: "Set up a mini basketball hoop and compete to score the most points.", duration: 15, age: 4 },
  { title: "Soccer Dribbling Challenge", genres: ["Sports"], description: "Dribble a soccer ball through a cone course to test speed.", duration: 15, age: 6 },
  { title: "Tennis Ball Target Practice", genres: ["Sports"], description: "Throw tennis balls at a target to test your aim.", duration: 15, age: 4 },
  { title: "Football Toss", genres: ["Sports"], description: "Throw a football into a hoop or bucket from a distance.", duration: 15, age: 6 },
  { title: "Kicking Accuracy Challenge", genres: ["Sports"], description: "Kick a soccer ball into targets for points.", duration: 15, age: 6 },

  # Video Games Genre
  { title: "Mario Party Mini-Games", genres: ["Video Games", "Others"], description: "Play a series of quick mini-games in Mario Party.", duration: 15, age: 6 },
  { title: "Among Us Game Night", genres: ["Video Games", "Others"], description: "Play the social deduction game Among Us with friends.", duration: 15, age: 8 },
  { title: "Animal Crossing Crafting", genres: ["Video Games", "Others"], description: "Craft and decorate items in Animal Crossing.", duration: 15, age: 4 },
  { title: "Super Mario Bros. Speed Run", genres: ["Video Games", "Others"], description: "Compete in a quick Super Mario Bros. run for the best time.", duration: 15, age: 6 },
  { title: "Fortnite Dance Off", genres: ["Video Games", "Dancing"], description: "Do the best Fortnite dance moves for fun.", duration: 15, age: 6 },

  # Dancing Genre
  { title: "Belly Dance Moves", genres: ["Dancing"], description: "Learn some basic belly dance moves and routines.", duration: 15, age: 6 },
  { title: "Salsa Dance Routine", genres: ["Dancing"], description: "Learn a quick salsa routine and perform it.", duration: 15, age: 8 },
  { title: "Breakdancing Battle", genres: ["Dancing"], description: "Compete in a breakdancing battle to show off your moves.", duration: 15, age: 6 },
  { title: "Line Dancing Challenge", genres: ["Dancing"], description: "Learn and perform simple line dances to popular songs.", duration: 15, age: 6 },
  { title: "TikTok Dance Challenge", genres: ["Dancing"], description: "Learn popular TikTok dances and perform them with friends.", duration: 15, age: 8 },

  # Singing Genre
  { title: "Singing in the Car", genres: ["Singing", "Others"], description: "Sing your favorite songs together while driving or sitting at home.", duration: 15, age: 4 },
  { title: "Glee Club Warm-Up", genres: ["Singing"], description: "Do vocal exercises to prepare for a group sing-along.", duration: 15, age: 6 },
  { title: "Opera Voice Challenge", genres: ["Singing"], description: "Try singing a song using dramatic opera-style vocals.", duration: 15, age: 6 },
  { title: "Pop Star Sing-Along", genres: ["Singing"], description: "Sing along to pop music hits and perform with friends.", duration: 15, age: 4 },
  { title: "Singing with a Karaoke App", genres: ["Singing", "Others"], description: "Sing your favorite songs using a karaoke app on your phone or TV.", duration: 15, age: 4 },

  # Other Genre
  { title: "Mindful Breathing", genres: ["Others"], description: "Practice mindful breathing exercises for relaxation.", duration: 15, age: 4 },
  { title: "DIY Birdhouse", genres: ["Others", "Arts & Crafts"], description: "Build and decorate a simple birdhouse.", duration: 15, age: 6 },
  { title: "Magic Sand Play", genres: ["Others", "Arts & Crafts"], description: "Create fun shapes and objects with colorful kinetic sand.", duration: 15, age: 4 },
  { title: "Treasure Map Hunt", genres: ["Others"], description: "Create a treasure map and go on an adventure to find hidden items.", duration: 15, age: 4 },
  { title: "Marshmallow Toss", genres: ["Others", "Sports"], description: "Toss marshmallows into a container or bucket and score points.", duration: 15, age: 4 },

  # More Activities
  { title: "DIY No-Sew Totes", genres: ["Arts & Crafts", "Others"], description: "Create simple fabric tote bags without sewing.", duration: 15, age: 6 },
  { title: "Make Your Own Slime", genres: ["Arts & Crafts", "Others"], description: "Create your own slime with basic household ingredients.", duration: 15, age: 4 },
  { title: "Paper Airplane Tournament", genres: ["Sports", "Others"], description: "Craft and race paper airplanes to see whose flies the farthest.", duration: 15, age: 4 },
  { title: "DIY Stress Balls", genres: ["Others", "Arts & Crafts"], description: "Create stress balls using balloons and flour or rice.", duration: 15, age: 6 },
  { title: "Obstacle Course Relay", genres: ["Sports", "Others"], description: "Complete an obstacle course in teams and compete for the fastest time.", duration: 15, age: 4 },
  { title: "Fun with Chalk", genres: ["Others", "Arts & Crafts"], description: "Draw on sidewalks or chalkboards and create colorful artwork.", duration: 15, age: 4 },
  { title: "Speedy Cup Stacking", genres: ["Others", "Sports"], description: "Stack and unstack cups as fast as possible in a race.", duration: 15, age: 4 },
  { title: "Create Your Own Comic", genres: ["Arts & Crafts", "Others"], description: "Design and draw your own comic strip.", duration: 15, age: 6 },
  { title: "DIY Pop-Up Cards", genres: ["Arts & Crafts", "Others"], description: "Create fun pop-up cards using paper and simple decorations.", duration: 15, age: 4 },
  { title: "Egg and Spoon Race", genres: ["Sports", "Others"], description: "Balance an egg on a spoon and race against others to the finish line.", duration: 15, age: 4 }
]

activities.each do |activity|
  Activity.create!(
    title: activity[:title],
    genres: activity[:genres],
    description: activity[:description],
    duration: activity[:duration],
    age: activity[:age]
  )
end

puts "Activities seeded successfully!"

puts "Adding Activities to Events..."
events.each do |event|
  Activity.all.sample(3).each do |activity|
    ActivitiesEvent.create!(activity: activity, event: event)
  end
end

puts "Seeding Complete!"

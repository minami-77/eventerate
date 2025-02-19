class Event < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :title, presence: true
  validates :date, presence: true
  validates :duration, presence: true
  has_many :activities_events, dependent: :destroy
  has_many :activities, through: :activities_events
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators
  has_many :tasks, dependent: :destroy

  attr_accessor :age_range, :num_activities

  def self.age_range_for_group(group)
    case group
    when 'Kindergarten'
      3...6
    when 'Elementary'
      7...11
    when 'High School'
      12...17
    when 'University'
      18...22
    when 'Corporate'
      23...100
    else
      0...100
    end
  end

  def generate_activities
    num_activities = self.num_activities.to_i
    age_range = self.class.age_range_for_group(self.age_range)
    event_title_words = self.title.downcase.split

    # Fetch activities based on age range
    available_activities = Activity.where(age: age_range)

    # Always include a "craft" activity if available
    craft_activity = available_activities.find_by('title ILIKE ?', '%craft%')

    # Filter activities based on event title words match or genre match
    matched_activities = available_activities.select do |activity|
      title_match = event_title_words.any? { |word| activity.title.downcase.include?(word) }
      genre_match = activity.genres.any? { |genre| event_title_words.include?(genre.downcase) }

      title_match || genre_match
    end

    # Remove the craft activity from matched activities if it's already included
    matched_activities -= [craft_activity] if craft_activity

    # If not enough matched activities, fallback to title match only
    if matched_activities.size < num_activities - 1
      additional_activities = Activity.all.select do |activity|
        event_title_words.any? { |word| activity.title.downcase.include?(word) }
      end
      matched_activities += additional_activities
      matched_activities.uniq!
    end

    # If still not enough, fallback to genre match only
    if matched_activities.size < num_activities - 1
      additional_activities = Activity.all.select do |activity|
        activity.genres.any? { |genre| event_title_words.include?(genre.downcase) }
      end
      matched_activities += additional_activities
      matched_activities.uniq!
    end

    # Select the remaining number of activities requested
    selected_activities = matched_activities.sample(num_activities - 1)

    # Add the craft activity to the selected activities
    selected_activities.unshift(craft_activity) if craft_activity

    selected_activities.each do |activity|
      ActivitiesEvent.create(activity: activity, event: self)
    end
  end

  def generate_activities_from_ai
    # Set up OpenAI client with API key
    client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])

    # Prepare event details to send to AI for activity suggestions
    event_details = {
      title: self.title,
      age_range: self.age_range,
      duration: self.duration,
      num_activities: self.num_activities.to_i
    }

    # Craft a prompt to send to the AI model, formatted as per your requirements
    prompt = <<~PROMPT
      Please provide a list of #{self.num_activities} fun and engaging activities for a summer camp for children aged #{self.age_range}.
      For each activity, provide the following details:

      1. **Activity Title**: A short and descriptive title of the activity.
      2. **Description**: A brief description of what the activity entails, including how it is conducted and any materials involved.
      3. **Step-by-Step Instructions**: Detailed instructions on how to conduct the activity.
      4. **Materials**: A list of materials needed for the activity.
      5. **Genre/Theme**: The genre or theme of the activity, such as “Adventure,” “Creative,” “Outdoor,” “Sports,” “Educational,” etc.
      6. **Age Range**: Specify the age group the activity is best suited for (e.g., 7-year-olds, 10-12-year-olds).

      Please format the response like this:

      1. **Title**: [Title of the activity]
        - **Description**: [Description of the activity]
        - **Step-by-Step Instructions**: [Instructions]
        - **Materials**: [Materials]
        - **Genre**: [Genre of the activity]
        - **Age**: [Age group suitable for this activity]
    PROMPT

    # Call the OpenAI API to generate activity suggestions
    response = client.chat(parameters: {
      model: 'gpt-3.5-turbo',
      messages: [{ role: "user", content: prompt }]
    })

    puts "AI Response: #{response.inspect}"

    # Extract the content from the AI response
    content = response.dig("choices", 0, "message", "content")
    activities = content.split("\n\n")  # Split by two newlines to separate activities

    # Process each activity and create an Activity object
    activities.each_with_index do |activity, index|
      # Extract the title, description, genre, and age range
      title_match = activity.match(/^\d+\.\s\*\*(.+)\*\*/)
      description_match = activity.match(/\*\*Description\*\*: (.+)/)
      instructions_match = activity.match(/\*\*Step-by-Step Instructions\*\*: (.+)/)
      materials_match = activity.match(/\*\*Materials\*\*: (.+)/)
      genre_match = activity.match(/\*\*Genre\*\*: (.+)/)
      age_match = activity.match(/\*\*Age\*\*: (.+)/)

      title = title_match ? title_match[1].strip : "Untitled"
      description = description_match ? description_match[1].strip : "No description available."
      instructions = instructions_match ? instructions_match[1].strip : "No instructions available."
      materials = materials_match ? materials_match[1].strip : "No materials specified."
      genre = genre_match ? genre_match[1].strip : "General"
      age_range = age_match ? age_match[1].strip : "Not specified"

      # Combine description, instructions, and materials into one description field
      full_description = <<~DESC
        **Description**: #{description}

        **Step-by-Step Instructions**: #{instructions}

        **Materials**: #{materials}
      DESC

      # Create a new Activity object with the extracted information
      activity_object = Activity.new(
        title: "#{index + 1}. #{title}",
        description: full_description,
        age: age_range.to_i, # Convert age range to an integer, may need further refinement
        genres: genre.split(',').map(&:strip) # Split genres by comma and trim whitespace
      )

      # # Save activity if valid
      # if activity_object.valid?
      #   activity_object.save
      #   ActivitiesEvent.create(activity: activity_object, event: self)
      # end

      # Print out the title, description, and genre for debugging
      puts "Activity Title: #{activity_object.title}"
      puts "Description: #{activity_object.description}"
      puts "Genre: #{genre}"
      puts "Age Range: #{age_range}"
    end
  end
end

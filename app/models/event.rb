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
    when 'Kindergarten' then '3-6'
    when 'Elementary'   then '7-11'
    when 'High School'  then '12-17'
    when 'University' then '18-22'
    when 'Corporate' then '23-100'
    else '0-100'
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
    client = OpenAI::Client.new(api_key: ENV.fetch('OPENAI_API_KEY'))

    # Prepare event details for AI prompt
    event_details = {
      title: self.title,
      title_keywords: self.title.downcase.split,
      age_range: self.class.age_range_for_group(self.age_range),
      duration: self.duration,
      num_activities: self.num_activities
    }

    # AI Prompt
    prompt = <<~PROMPT
      Please provide a list of #{event_details[:num_activities]} fun and engaging activities for an event titled "#{event_details[:title]}" for participants ages from #{event_details[:age_range]} years old.
      The event duration is #{event_details[:duration]} minutes.
      Format the response in valid JSON as an array of activities, where each activity contains:
      - title (string)
      - description (string)
      - step_by_step (array of strings)
      - materials (array of strings)
      - genre (string)
      - age (integer)

      Example:
      { "activities": [
        {
          "title": "Spooky Scavenger Hunt",
          "description": "Participants search for hidden Halloween-themed items.",
          "step_by_step": ["Hide items", "Divide into teams", "Find items"],
          "materials": ["Plastic spiders", "Fake skeletons"],
          "genre": "Adventure",
          "age": 7
        }
  ]}
    PROMPT
    # raise
    # Call the OpenAI API
    response = client.chat(parameters: {
      model: "gpt-4o",
      messages: [{ role: "user", content: prompt }],
      response_format: { type: "json_object" }
      # response_format: "json" # Ensure JSON response format
    })

    puts "AI Response: #{response.inspect}"

    # Extract the content from AI response
    p content = response.dig("choices", 0, "message", "content")

    # Ensure the response is in valid JSON format
    # json_start = content.index('[')
    # json_end = content.rindex(']')
    # json_content = content[json_start..json_end]

    # raise
    # Parse JSON response safely
    begin
      activities = JSON.parse(content)
    rescue JSON::ParserError => e
      puts "Error parsing AI response: #{e.message}"
      return []
    end
    activities["activities"].map do |activity|
      title = activity["title"] || "Untitled"
      description = activity["description"] || "No description available."
      step_by_step = activity["step_by_step_instructions"] || []
      materials = activity["materials"] || []

      # Format the full description by combining details
      full_description = <<~DESC
        **Description**: #{description}

        **Step-by-Step Instructions**:
        #{step_by_step.map.with_index(1) { |step, i| "#{i}. #{step}" }.join("\n")}

        **Materials**: #{materials.join(', ')}
      DESC

      genre = activity["genre_theme"] || "General"
      age = activity["age_range"] || "Not specified"

      # Create a new Activity object
      Activity.new(
        title: title,
        description: full_description,
        age: age.to_i,
        genres: [genre] # Convert to an array
      )

      # # Save activity if valid
      # if activity_object.valid?
      #   activity_object.save
      #   ActivitiesEvent.create(activity: activity_object, event: self)
    # end

      # Print out the title, description, and genre for debugging
      # puts "Activity Title: #{activity_object.title}"
      # puts "Description: #{activity_object.description}"
      # puts "Genres: #{activity_object.genres}"
      # puts "Age Range: #{activity_object.age}"
    end
    # activity_object
  end
end

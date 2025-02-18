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
    # Set up OpenAI client
    client = OpenAI::Client.new

    # Prepare event details to send to AI for activity suggestions
    event_details = {
      title: self.title,
      age_range: self.age_range,
      duration: self.duration,
      num_activities: self.num_activities.to_i
    }

    # Craft a prompt to send to the AI model
    prompt = "Generate #{self.num_activities} activities for an event titled '#{self.title}'
            for a group of #{self.age_range} students. The event will last for #{self.duration} hours.
            Activities should be engaging, age-appropriate, and creative.
            Please provide a genre and description for each activity, separated by commas."

    # Call the OpenAI API to generate activity suggestions
    response = client.chat(parameters: {
      model: 'gpt-3.5-turbo',
      messages: [{ role: "user", content: prompt }]
    })

    # Parse the response (this depends on the OpenAI response structure)
    activity_titles = response.dig("choices", 0, "message", "content").split("\n")

    activities = []

    # Loop through the activity titles and create activities in memory (without saving)
    activity_titles.each do |title|
      if title.present?
        # Attempt to extract genres from AI response (you can adjust this logic)
        genres = title.match(/Genres: (.+)$/) ? title.match(/Genres: (.+)$/)[1].split(', ') : []

        # Make sure genres is not empty
        genres = ['General'] if genres.empty?

        # Create activity with the title, age range, and genres in memory
        activity = Activity.new(title: title.strip, age: age_range, genres: genres)

        activities << activity
      end
    end

    # Return the activities in memory so that the user can decide if they want to save the event
    activities
  end
end

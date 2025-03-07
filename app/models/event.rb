class Event < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :title, presence: true
  validates :date, presence: true
  validates :duration, presence: true

  has_many :activities_events, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators
  has_many :tasks, dependent: :destroy

  has_one :chat, dependent: :destroy

  attr_accessor :age_range, :num_activities

  def start_time
    date
  end

  def completion_percentage
    return "0%" if tasks.count.zero?

    percentage = (tasks.where(completed: true).count.to_f / tasks.count * 100).round
    "#{percentage}%"
  end
  def unfinished_tasks(user)
    # Returns number of unfinished tasks that belongs to user
    tasks.where(completed: false, users: { id: user.id }).joins(:users).count
  end

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
      ActivitiesEvent.create(activity: activity, event: self, custom_title: activity.title, custom_description: activity.description)
    end
  end

  # def regenerate_activities(selected_activity_ids, num_activities_to_generate, age_range)
  #   # Keep selected activities
  #   kept_activities = Activity.where(id: selected_activity_ids)

  #   # Generate new activities using AI
  #   generated_activities = generate_activities_from_ai(age_range, num_activities_to_generate)

  #   # Save generated activities and associate them with this event
  #   generated_activities.each do |activity|
  #     if activity.save
  #       ActivitiesEvent.create(activity: activity, event: self)
  #     else
  #       Rails.logger.info activity.errors.full_messages
  #     end
  #   end

  #   # Assign the final activities list to the event
  #   self.activities = kept_activities + generated_activities
  #   save
  # end

  def generate_activities_from_ai(age_range, num_activities)
    age_range = self.class.age_range_for_group(age_range)
    event_details = {
      title: self.title,
      title_keywords: self.title.downcase.split,
      age_range: age_range,
      duration: self.duration,
      num_activities: num_activities
    }
    client = OpenAI::Client.new(api_key: ENV.fetch('OPENAI_API_KEY'))

    # AI Prompt
    prompt = <<~PROMPT
      Please provide a list of #{event_details[:num_activities]} fun and engaging activities for an event titled "#{event_details[:title]}" for participants ages from #{event_details[:age_range]} years old.
      The event duration is #{event_details[:duration]} minutes. Each activity's duration added up should total the total event duration.

      Format the response in valid JSON as an array of activities, where each activity contains:
      - title (string)
      - description (string)
      - instructions (array of strings)
      - materials (array of strings)
      - age (integer)
      - duration in minutes (integer)

      Please ensure all arrays have closing brackets

      Example:
      { "activity": [
        {
          "title": "Spooky Scavenger Hunt",
          "description": "Participants search for hidden Halloween-themed items.",
          "instructions": ["Hide items", "Divide into teams", "Find items"],
          "materials": ["Plastic spiders", "Fake skeletons"],
          "duration" : 10,
          "age": 7
        }
      ]}
    PROMPT

    response = client.chat(parameters: {
      model: "gpt-4o",
      messages: [{ role: "user", content: prompt }],
      response_format: { type: "json_object" }
    })

    content = response.dig("choices", 0, "message", "content")

    begin
      activities = JSON.parse(content)
    rescue JSON::ParserError => e
      puts "Error parsing AI response: #{e.message}"
      return []
    end

    activities
    # activities["activities"].map do |activity_data|
    #   title = activity_data["title"] || "Untitled"
    #   description = activity_data["description"] || "No description available."
    #   step_by_step = activity_data["step_by_step"] || []
    #   materials = activity_data["materials"] || []
    #   genre = activity_data["genre"] || "General"
    #   age = activity_data["age"] || 0

    #   # Construct full description
    #   full_description = <<~DESC
    #     **Description**: #{description}

    #     **Step-by-Step Instructions**:
    #     #{step_by_step.map.with_index(1) { |step, i| "#{i}. #{step}" }.join("\n")}

    #     **Materials**: #{materials.join(', ')}
    #   DESC

    #   Activity.new(
    #     title: title,
    #     description: full_description,
    #     age: age.to_i,
    #     genres: [genre] # Convert to an array
    #   )
    # end
  end
end

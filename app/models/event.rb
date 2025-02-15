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
      3..6
    when 'Elementary'
      7..11
    when 'High School'
      12..17
    when 'University'
      18..22
    when 'Corporate'
      23..100
    else
      0..100
    end
  end

  def generate_activities
    num_activities = self.num_activities.to_i
    event_title_words = self.title.downcase.split

    # Fetch activities, first by age range
    age_range = self.class.age_range_for_group(self.age_range)
    available_activities = Activity.where(age: age_range)

    # If no activities match the age range, allow all activities
    available_activities = Activity.all if available_activities.empty?

    # Debugging: Print activities fetched
    puts "Available activities (#{available_activities.count}): #{available_activities.map(&:title)}"

    # Step 1: Match activities by genre (prioritized)
    genre_matches = available_activities.select do |activity|
      activity.genres.any? { |genre| event_title_words.any? { |word| fuzzy_match(word, genre) } }
    end

    # Step 2: Match activities by title
    title_matches = available_activities.select do |activity|
      event_title_words.any? { |word| fuzzy_match(word, activity.title) }
    end

    # Step 3: Merge results and remove duplicates
    selected_activities = (genre_matches + title_matches).uniq

    # Step 4: If we still don't have enough, add random activities
    if selected_activities.size < num_activities
      additional_activities = (available_activities - selected_activities).sample(num_activities - selected_activities.size)
      selected_activities += additional_activities
    end

    # Step 5: Limit to the required number of activities
    selected_activities = selected_activities.first(num_activities)

    # Debugging: Final activities selected
    puts "Final activities selected: #{selected_activities.map(&:title)}"

    # Save selected activities to the event
    selected_activities.each do |activity|
      ActivitiesEvent.create(activity: activity, event: self)
    end
  end

  # Helper function to match words including plural/singular variations
  def fuzzy_match(word, text)
    singular_word = word.singularize
    plural_word = word.pluralize
    text.downcase.include?(word) || text.downcase.include?(singular_word) || text.downcase.include?(plural_word)
  end
end

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
      [3..6]
    when 'Elementary'
      [7..11]
    when 'High School'
      [12..17]
    when 'University'
      [18..22]
    when 'Corporate'
      [23..100]
    else
      [0..100]
    end
  end

  def generate_activities
    num_activities = self.num_activities.to_i
    age_range = self.age_range
    event_title = self.title.downcase

    # get the age range based on input
    age_range = Event.age_range_for_group(age_range)

    # fetch activities based on age range
    available_activities = Activity.where(age: age_range)

    # Filter activities based on event title match or genre match
    matched_activities = available_activities.select do |activity|
      title_match = activity.title.downcase.include?(event_title)
      genre_match = activity.genres.any? { |genre| genre.downcase.include?(event_title) }

      title_match || genre_match
    end

    selected_activities = matched_activities.sample(num_activities)

    # Select the number of activities requested
    selected_activities.each do |activity|
      ActivitiesEvent.create(activity: activity, event: self)
    end
  end
end

class Task < ApplicationRecord
  belongs_to :event
  belongs_to :activity
  has_many :tasks_users, dependent: :destroy
  has_many :users, through: :tasks_users

  has_one_attached :photo
  validates :event, presence: true
  attr_accessor :user_id, :suggestions

  # For OpenAI
  def content(activity_list)
    # activity_list =
    #    if generated_activities.present?
    #      generated_activities.map do |activity|
    #        {
    #          title: activity["title"],
    #          description: activity["description"],
    #          age: activity["age"],
    #          genres: activity["genres"]
    #        }
    #      end
    #   elsif self.event.activities.present?
    #     self.event.activities.map do |activity|
    #       {
    #         title: activity.title,
    #         description: activity.description,
    #         age: activity.age,
    #         genres: activity.genres
    #       }
    #     end
    #   else
    #     []
    # end

    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{
        role: "user",
        response_format: { type: "json_object" },

        # AI prompt
        content:
          "
          Please provide a list of preparation tasks for each activity and general event preparations below:
          - Event title:#{self.event.title}
          - Activities:#{activity_list}

          Each task should be concise and **no longer than 50 words**.
          Ensure that all tasks are clear, actionable, and related to event preparation.
          Tasks for each activity should only include **preparations required before the event day**.
          **Do not include on-the-day setup or logistics** in activity tasks.

          - Exclude the existing tasks listed below:
            #{self.event.tasks.where.not(title: nil).map(&:title).join(', ').presence || 'None'}

          Format the response as valid JSON,
          using an object where each activity is a key with an array of preparation tasks as its value:
            {
              'Activity Title (string)': ['task', 'task', 'task'],
              'Another Activity Title (string)': ['task', 'task', 'task']
            }
          "
        }]
      })

    # Store AI answer(string) into variable response_text
    response_text = chatgpt_response.dig("choices", 0, "message", "content")
    return [] if response_text.nil? || response_text.empty?

    # Parse JSON response safely
    begin
      suggestions = JSON.parse(response_text)
    rescue JSON::ParserError => e
      Rails.logger.error "Error parsing AI response: #{e.message}"
      return []
    end

    Rails.logger.info "AI Suggestions: #{suggestions}"

    @suggestions = suggestions

  end
end

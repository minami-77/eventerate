class Task < ApplicationRecord
  belongs_to :event
  has_many :tasks_users, dependent: :destroy
  has_many :users, through: :tasks_users

  has_one_attached :photo
  validates :event, presence: true
  attr_accessor :user_id, :suggestions

  # For OpenAI
  def content
    Rails.cache.fetch("#{cache_key_with_version}/content") do
      client = OpenAI::Client.new
      chatgpt_response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [{
          role: "user",
          # AI prompt #
          content:
            "
            Generate 5 specific tasks that need to be done for the event: #{self.event.title},
            which is aimed at students (kindergarten, elementary school, or high school).
            These tasks should be directly related to preparing the event, with a focus on the activities included.
            For reference, here are the activities in the event.
            #{self.event.activities.map { |activity|
              activity.age.present? ? "#{activity.title} (Age: #{activity.age})" : activity.title }.join(', ')
            }
            Ensure the tasks are directly connected to the activities listed above,
            and make sure the tasks are actionable preparations.
            Do not include the existing tasks listed below:
            #{if self.event.tasks.any?
                self.event.tasks.where.not(title: nil).map { |task| task.title }.join(', ')
              else
                "None"
              end}
              Format the response in valid an array of tasks:

            "
        }]
      })
      # Store AI answer(string) into variable response_text
      response_text = chatgpt_response.dig("choices", 0, "message", "content")
      puts "********************************************************************"
      puts "********************************************************************"
      puts "********************************************************************"
      puts "********************************************************************"

      puts response_text

      @suggestions = response_text.split("\n").map{|suggestion|suggestion.strip}
      return @suggestions[1..-2]

    end
  end
end

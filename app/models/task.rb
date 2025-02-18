class Task < ApplicationRecord
  belongs_to :event
  has_many :tasks_users, dependent: :destroy
  has_many :users, through: :tasks_users

  validates :event, presence: true
  attr_accessor :user_id

  def content
    Rails.cache.fetch("#{cache_key_with_version}/content") do
      client = OpenAI::Client.new
      chatgpt_response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [{ role: "user",
          content:"
            Generate 5 specific tasks that need to be done for the event: #{self.event.title},
            which is aimed at students (kindergarten, elementary school, or high school).
            These tasks should be directly related to preparing the event, with a focus on the activities included.
            For reference, here are the activities in the event:
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
            Provide only the list of tasks without any introductory phrases or explanations.
            Format the response as follows:
            1. Task 1
            2. Task 2
            3. Task 3
            4. Task 4
            5. Task 5
            "
        }]
      })
      chatgpt_response["choices"][0]["message"]["content"]

    end
  end
end

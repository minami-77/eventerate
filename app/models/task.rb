class Task < ApplicationRecord
  belongs_to :event
  has_many :tasks_users, dependent: :destroy
  has_many :users, through: :tasks_users

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
            Provide only the list of tasks without any introductory phrases or explanations.
            Separate each task using '#' without numbering them.
            Example format: 'Prepare materials for crafts # Set up game stations # Organize supplies'
            DO NOT include numbering such as 'Task 1', 'Task 2', etc.
            "
        }]
      })
      # Store AI answer(string) into variable response_text
      response_text = chatgpt_response["choices"][0]["message"]["content"]
      puts "********************************************************************************************************************************************"
      puts "********************************************************************************************************************************************"
      puts "********************************************************************************************************************************************"
      puts "********************************************************************************************************************************************"
      puts "********************************************************************************************************************************************"
      puts "********************************************************************************************************************************************"
      puts "********************************************************************************************************************************************"
      puts "********************************************************************************************************************************************"
      puts "********************************************************************************************************************************************"
      puts "********************************************************************************************************************************************"

      puts response_text
      @suggestions = response_text.split("#").map{|suggestion|suggestion.strip}.first(5)
      return @suggestions

    end
  end
end

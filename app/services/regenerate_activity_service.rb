require 'json'

class RegenerateActivityService
  def self.regenerate_activity(event_title, age_range, activity_title = "")

    if activity_title != ""
      current_activity_title_parameter = "The title of the new activity (as well as the activity itself) should be very different to the current activity #{activity_title}."
    else
      current_activity_title_parameter = ""
    end

    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{
        role: "user",
        response_format: { type: "json_object" },

        # AI prompt
        content:
          <<~PROMPT
          Please provide an appropriate specific themed activity for an event called #{event_title} and age range of #{age_range}, as well as a list of condensed tasks (no more than 4) that would be required to prepare for this event.

          The activity should have a description of what the activity is, as well as step by step instructions (no more than 4) for how to carry out the activity on the day of the event, as well as materials that would be needed.

          The title of the new activity (as well as the activity itself) should be very different to the current activity #{activity_title}.

          Do not give me any of the same activities you have given in the last few minutes

          Each task should be concise and **no longer than 15 words**.
          Ensure that all tasks are clear, actionable, and related to event preparation.

          the step by step instructions and tasks should be formatted as an array in the appropriate sections.

          Please do not include full stops at the end of the instructions and tasks

          Do not include bullet points or numbering in the instructions (i.e. '1.', '2.', 'Step 1', 'Step 2', etc.)

          Ensure all arrays have closing brackets

          Format the response as valid JSON object
            {
              title: *title of generated activity*,
              description: *simple description of generated activity*,
              instructions: [*array of step by step instructions*],
              materials: [*array of materials*],
              tasks: [*array of tasks*]
            }
          PROMPT
        }]
      })

    response_content = chatgpt_response.dig("choices", 0, "message", "content")
    JSON.parse(response_content)
  end
end

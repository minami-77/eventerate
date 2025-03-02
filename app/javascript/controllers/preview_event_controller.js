import { Controller } from "@hotwired/stimulus";

const activities = {
  "activities": [
    {
      "title": "Easter Egg Hunt",
      "description": "Children search for hidden Easter eggs around the event area.",
      "step_by_step": ["Hide Easter eggs around the venue", "Explain the rules to the children", "Guide children to start searching", "Encourage all participants to find eggs", "Conclude the hunt and distribute small prizes"],
      "materials": ["Plastic eggs", "Small prizes or candy"],
      "genre": "Adventure",
      "age": 3
    },
    {
      "title": "Easter Bunny Dance",
      "description": "An energetic dance session led by an instructor dressed as the Easter Bunny.",
      "step_by_step": ["Gather the children around the dance area", "Introduce the Easter Bunny and demonstrate simple dance moves", "Play lively Easter-themed music", "Encourage children to follow along with the Bunny", "Conclude with a fun dance-off and clapping session"],
      "materials": ["Easter Bunny costume", "Speakers", "Easter-themed music"],
      "genre": "Dance",
      "age": 4
    },
    {
      "title": "Easter Crafting",
      "description": "A hands-on crafting activity where children create Easter decorations.",
      "step_by_step": ["Provide each child with a crafting kit", "Guide them through making an Easter basket", "Allow time to decorate the baskets with stickers and colors", "Assist as needed", "Display all the crafted items for everyone to see"],
      "materials": ["Craft paper", "Markers", "Stickers", "Glue", "Safety scissors"],
      "genre": "Art",
      "age": 5
    },
    {
      "title": "Storytime with Easter Tales",
      "description": "A storytelling session featuring Easter-themed tales.",
      "step_by_step": ["Set up a comfortable seating area", "Choose a couple of Easter-themed picture books", "Read the stories aloud to the children", "Engage children by asking questions", "Conclude with a group discussion on their favorite parts"],
      "materials": ["Easter-themed picture books"],
      "genre": "Storytelling",
      "age": 3
    },
    {
      "title": "Easter Egg Roll Race",
      "description": "A fun race where children roll eggs across the floor.",
      "step_by_step": ["Set up a starting line and a finish line", "Provide each child with a plastic egg and a spoon", "Instruct them on rolling the egg with the spoon", "Start the race with a simple start signal", "Cheer on the participants and celebrate everyone's efforts"],
      "materials": ["Plastic eggs", "Plastic spoons", "Markers for lines"],
      "genre": "Games",
      "age": 6
    }
  ]
};

export default class extends Controller {
  static targets = ["activity"];

  connect() {
    console.log("Preview Event Controller connected!");
  }

  regenerate(event) {
    event.preventDefault();
    const currentActivityTitle = event.currentTarget.getAttribute("data-activity-title");
    const activityElement = event.currentTarget.closest("[data-preview-event-target='activity']");

    // Get all currently displayed activity titles
    const displayedActivityTitles = Array.from(document.querySelectorAll("[data-preview-event-target='activity'] .card-title"))
      .map(element => element.textContent.trim());

    // Filter out the current activity to avoid selecting it again
    const otherActivities = activities.activities.filter(act => !displayedActivityTitles.includes(act.title));
    const randomActivity = otherActivities[Math.floor(Math.random() * otherActivities.length)];

    if (randomActivity) {
      const fullDescription = `
        <div class="card mb-3 activity-preview" data-preview-event-target="activity">
          <div class="card-body" data-controller="preview-event">
            <h4 class="card-title" data-target="preview-event.activity">
              ${randomActivity.title}
              <button
                data-action="click->preview-event#regenerate"
                data-activity-title="${randomActivity.title}"
                class="btn btn-primary regenerate-btn">
                Regenerate Activity
              </button>
            </h4>
            <p>${randomActivity.description.split("\n\n")[0].replace("**Description**: ", "")}</p>
            ${randomActivity.step_by_step.map(step => `<p>${step}</p>`).join('')}
            <p><strong>Materials:</strong> ${randomActivity.materials.join(', ')}</p>
            <p><strong>Genres:</strong> ${randomActivity.genre}</p>
            <p><strong>Age Range:</strong> ${randomActivity.age}</p>

            <!-- Hidden fields to preserve activity details -->
            <input type="hidden" name="activities[][title]" value="${randomActivity.title}">
            <input type="hidden" name="activities[][description]" value="${randomActivity.description}">
            <input type="hidden" name="activities[][genres]" value='["${randomActivity.genre}"]'>
            <input type="hidden" name="activities[][age]" value="${randomActivity.age}">
          </div>
        </div>
      `;

      activityElement.outerHTML = fullDescription;
    } else {
      console.error("No other activities found.");
    }
  }
}

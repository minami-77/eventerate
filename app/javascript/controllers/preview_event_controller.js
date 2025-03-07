import { Controller } from "@hotwired/stimulus";

const activities = {
  "activities": [
    {
      "title": "Easter Egg Hunt",
      "description": "Children search for hidden Easter eggs around the event area.",
      "instructions": ["Hide Easter eggs around the venue", "Explain the rules to the children", "Guide children to start searching", "Encourage all participants to find eggs", "Conclude the hunt and distribute small prizes"],
      "materials": ["Plastic eggs", "Small prizes or candy"],
      "genre": "Adventure",
      "age": 3,
      "tasks": [
        "Plan venue layout and gather materials (eggs, prizes)",
        "Assign staff for setup and supervision",
        "Hide eggs and prepare gathering area",
        "Explain rules, start hunt, and distribute prizes"
      ]
    },
    {
      "title": "Easter Bunny Dance",
      "description": "An energetic dance session led by an instructor dressed as the Easter Bunny.",
      "instructions": ["Gather the children around the dance area", "Introduce the Easter Bunny and demonstrate simple dance moves", "Play lively Easter-themed music", "Encourage children to follow along with the Bunny", "Conclude with a fun dance-off and clapping session"],
      "materials": ["Easter Bunny costume", "Speakers", "Easter-themed music"],
      "genre": "Dance",
      "age": 4,
      "tasks": [
        "Gather children around the dance area and set up music",
        "Dress the instructor in the Easter Bunny costume",
        "Play lively Easter-themed music and demonstrate dance moves",
        "Encourage kids to follow the dance moves and conclude with a dance-off"
      ]
    },
    {
      "title": "Easter Crafting",
      "description": "A hands-on crafting activity where children create Easter decorations.",
      "instructions": ["Provide each child with a crafting kit", "Guide them through making an Easter basket", "Allow time to decorate the baskets with stickers and colors", "Assist as needed", "Display all the crafted items for everyone to see"],
      "materials": ["Craft paper", "Markers", "Stickers", "Glue", "Safety scissors"],
      "genre": "Art",
      "age": 5,
      "tasks": [
        "Gather and organize crafting supplies",
        "Set up tables with enough space for participants",
        "Guide children through crafting activities",
        "Display finished crafts and assist with cleanup"
      ]
    },
    {
      "title": "Storytime with Easter Tales",
      "description": "A storytelling session featuring Easter-themed tales.",
      "instructions": ["Set up a comfortable seating area", "Choose a couple of Easter-themed picture books", "Read the stories aloud to the children", "Engage children by asking questions", "Conclude with a group discussion on their favorite parts"],
      "materials": ["Easter-themed picture books"],
      "genre": "Storytelling",
      "age": 3,
      "tasks": [
        "Select and review Easter-themed books",
        "Arrange a cozy seating area",
        "Read stories and engage children with questions",
        "Wrap up with a group discussion"
      ]
    },
    {
      "title": "Easter Egg Roll Race",
      "description": "A fun race where children roll eggs across the floor.",
      "instructions": ["Set up a starting line and a finish line", "Provide each child with a plastic egg and a spoon", "Instruct them on rolling the egg with the spoon", "Start the race with a simple start signal", "Cheer on the participants and celebrate everyone's efforts"],
      "materials": ["Plastic eggs", "Plastic spoons", "Markers for lines"],
      "genre": "Games",
      "age": 6,
      "tasks": [
          "Mark race track and prepare materials (eggs, spoons)",
          "Explain race rules to participants",
          "Supervise race and ensure fair play",
          "Celebrate participation and hand out small rewards"
      ]
    },
    {
      "title": "Easter Egg Decorating",
      "description": "A creative activity where kids decorate eggs with various craft supplies.",
      "instructions": ["Boil the eggs in advance", "Set up a decorating station", "Introduce the decorating tools and supplies", "Assist the kids as needed while they decorate"],
      "materials": ["Hard-boiled eggs", "Markers", "Stickers", "Glue", "Glitter"],
      "genre": "Arts & Crafts",
      "age": 3,
      "tasks": [
        "Boil eggs in advance and gather decorating materials",
        "Set up a decorating station with markers, stickers, and glitter",
        "Introduce decorating tools to the kids",
        "Assist children as they decorate their eggs"
      ]
    },
    {"title": "Musical Bunny Ears",
      "description": "A fun twist on musical chairs involving bunny ears.",
      "instructions": ["Place bunny ears in a circle on the ground", "Play Easter-themed music", "Have kids walk around the circle", "Stop the music and have kids grab ears to wear"],
      "materials": ["Bunny ears", "Music player"],
      "genre": "Music & Movement",
      "age": 3,
      "tasks": [
        "Place bunny ears in a circle on the ground",
        "Prepare Easter-themed music and music player",
        "Guide children to walk around the circle while music plays",
        "Stop the music and have children grab bunny ears"
      ]
    },
    {"title": "Easter Parade",
      "description": "Kids dress in Easter-themed costumes and parade around the venue.",
      "instructions": ["Provide various costume accessories", "Enable each child to choose and dress up", "Organize them into a simple parade line", "Lead them on a short parade around the venue"],
      "materials": ["Costume accessories", "Bunny ears", "Easter hats"],
      "genre": "Drama",
      "age": 5,
      "tasks": [
        "Provide costume accessories like bunny ears and Easter hats",
        "Help children dress up in their chosen costumes",
        "Organize children into a parade line",
        "Lead the parade around the venue"
      ]
    },
    {
      "title": "Egg Toss Game",
      "description": "A fun practice in precision where kids toss eggs into baskets.",
      "instructions": ["Set up baskets at varying distances", "Explain how to toss the eggs", "Give each child multiple tries to land in a basket", "Encourage and assist them as needed"],
      "materials": ["Plastic eggs", "Baskets"],
      "genre": "Physical Play",
      "age": 4,
      "tasks": [
        "Set up baskets at various distances",
        "Explain how to toss eggs into the baskets",
        "Give each child multiple tries to land eggs in the baskets",
        "Encourage children and provide assistance if needed"
      ]
    },
    {"title": "Easter Sing-Along",
      "description": "An engaging session of singing Easter and spring-themed songs.",
      "instructions": ["Prepare a playlist of Easter-themed songs", "Encourage participation in singing", "Use simple musical instruments for best interaction", "Guide kids through different songs"],
      "materials": ["Song lyrics sheets", "Musical instruments like tambourines"],
      "genre": "Music & Movement",
      "age": 3,
      "tasks": [
        "Prepare a playlist of Easter and spring songs",
        "Encourage children to participate in singing",
        "Provide tambourines or simple instruments for interaction",
        "Guide children through the songs with fun movements"
      ]
    },
    {
      "title": "Easter Bunny Dance",
      "description": "An energetic dance session led by an instructor dressed as the Easter Bunny.",
      "instructions": ["Gather the children around the dance area", "Introduce the Easter Bunny and demonstrate simple dance moves", "Play lively Easter-themed music", "Encourage children to follow along with the Bunny", "Conclude with a fun dance-off and clapping session"],
      "materials": ["Easter Bunny costume", "Speakers", "Easter-themed music"],
      "genre": "Dance",
      "age": 4,
      "tasks": [
        "Gather children around the dance area and set up music",
        "Dress the instructor in the Easter Bunny costume",
        "Play lively Easter-themed music and demonstrate dance moves",
        "Encourage kids to follow the dance moves and conclude with a dance-off"
      ]
    }
  ]
};

export default class extends Controller {
  static targets = ["activity", "task", "saveButton", "rotate"];

  connect() {
    console.log("Preview Event Controller connected!");
  }

  submit(event) {
    const button = this.saveButtonTarget;

    // Prevent multiple clicks
    if (button.dataset.saving === "true") return;

    button.dataset.saving = "true";
    button.classList.add("saving");

    // Change text and show spinner
    button.querySelector(".button-text").textContent = "Saving...";
    button.querySelector(".loading-spinner").classList.remove("d-none");
  }

  regenerate(event) {
    event.preventDefault();
    const currentActivityTitle = event.currentTarget.getAttribute("data-activity-title");
    const activityElement = event.currentTarget.closest("[data-preview-event-target='activity']");

    // Get all currently displayed activity titles
    const displayedActivityTitles = Array.from(document.querySelectorAll("[data-preview-event-target='activity']"))
      .map(element => element.getAttribute("data-activity-title"));

    this.rotateTarget.classList.add("rotate-this");
    // Set timeout for imitating realism
    setTimeout(() => {
      // Filter out the current activity to avoid selecting it again
      const otherActivities = activities.activities.filter(act => !displayedActivityTitles.includes(act.title));
      const randomActivity = otherActivities[Math.floor(Math.random() * otherActivities.length)];

      if (randomActivity) {
        const stepByStepInstructions = randomActivity.instructions.map((step, index) => `${index + 1}. ${step}`).join("<br><br>");
        const collapseId = `details-${randomActivity.title.replace(/\s+/g, '-').toLowerCase()}`;
        const fullDescription = `
          <div class="card shadow-sm border-0 mb-4 activity-card background-white" data-preview-event-target="activity" data-activity-title="${randomActivity.title}">
            <div class="card-body" data-controller="preview-event">
              <div class="d-flex justify-content-between align-items-center">
                  <h4 class="card-title mb-0">
                    ${randomActivity.title}
                  </h4>
                  <button
                    data-action="click->preview-event#regenerate"
                    data-activity-title="${randomActivity.title}"
                    class="btn btn-link p-0 regenerate-btn">
                    <i class="fa-solid fa-arrows-rotate" data-preview-event-target="rotate"></i>
                  </button>
                </div>
                <p class="mb-1"><i class="fas fa-info-circle"></i> ${randomActivity.description.split("\n\n")[0].replace("**Description**: ", "")}</p>
                <a class="d-flex justify-content-center text-decoration-none" type="button" data-bs-toggle="collapse" data-bs-target="#${collapseId}">
                  <i class="fa-solid fa-circle-chevron-down mt-2" style="color: #000000"></i>
                </a>
                <div class="collapse mt-3" id="${collapseId}">
                  <p><strong>Step-by-Step Instructions:</strong></p>
                  <p>${stepByStepInstructions}</p>
                  <p><strong>Materials:</strong> ${randomActivity.materials.join(', ')}</p>
                </div>

                <!-- Hidden fields to preserve activity details -->
            <input type="hidden" name="activities[][title]" value="${randomActivity.title}">
            <input type="hidden" name="activities[][description]" value="${randomActivity.description}">
            <input type="hidden" name="activities[][materials]" value='${JSON.stringify(randomActivity.materials)}'>
            <input type="hidden" name="activities[][instructions]" value='${JSON.stringify(randomActivity.instructions)}'>
            <input type="hidden" name="activities[][age]" value="${randomActivity.ageRange}">
              </div>
            </div>
          </div>
        `;

        // Replace the activity content
        activityElement.outerHTML = fullDescription;

        // Update the tasks
        this.updateTaskContent(randomActivity.title, currentActivityTitle);
      } else {
        console.error("No other activities found.");
      }
    }, 2000);
  }

  updateTaskContent(activityTitle, currentActivityTitle) {
    const taskHTML = this.generateTaskHTML(activityTitle);

    console.log('Updating task content for:', activityTitle);

    // Find the corresponding task container (outside of the activity card, as requested)
    let taskContainer = document.querySelector(`[data-preview-event-target="task"][data-activity-title="${currentActivityTitle}"]`);
    taskContainer.setAttribute("data-activity-title", activityTitle);

    // If task container doesn't exist, create a new one
    if (!taskContainer) {
        console.log('Task container not found, creating a new one.');
        const activityElement = document.querySelector(`[data-preview-event-target="activity"][data-activity-title="${activityTitle}"]`);

        // Create a new task container
        const newTaskContainer = document.createElement("div");
        newTaskContainer.setAttribute("data-preview-event-target", "task");
        newTaskContainer.setAttribute("data-activity-title", activityTitle);

        // Append the new task container inside the activity
        activityElement.appendChild(newTaskContainer);

        // Now taskContainer points to the newly created container
        taskContainer = newTaskContainer;
    }
  // Clear the existing tasks and insert the new task HTML
  taskContainer.innerHTML = taskHTML;
}

  generateTaskHTML(activityTitle) {
    // Find the matching activity
    const activity = activities.activities.find(act => act.title === activityTitle);

    if (activity && activity.tasks.length > 0) {
        return `
              <ul class="list-group list-group-flush">
              ${activity.tasks.map(task => `<li class="list-group-item task-item background-white">${task}</li><input type="hidden" name="activities[][tasks][]" value="${task}">`).join('')}
              </ul>
        `;
    } else {
        return "<p>No tasks available for this activity.</p>";
    }
  }
}

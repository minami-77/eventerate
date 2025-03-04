import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="real-preview-event"
export default class extends Controller {
  connect() {
  }

  async regenerate(event) {
    event.preventDefault();
    console.log(event.currentTarget);
    const ageRange = event.currentTarget.getAttribute("data-age-range");
    const eventTitle = event.currentTarget.getAttribute("data-event");
    const response = await fetch(`/regenerate_activity?age_range=${ageRange}&event_title=${eventTitle}`);
    const data = await response.json();
    if (data) {
      this.replaceActivity(data, ageRange, eventTitle, event);
    }
  }

  replaceActivity(data, ageRange, eventTitle, event) {
    console.log(data);
    const fullDescription = this.fullDescription(data, ageRange, eventTitle);
    const activityElement = event.target.closest("[data-preview-event-target='activity']");
    this.updateTasks(activityElement, data);
    activityElement.outerHTML = fullDescription;
  }

  updateTasks(activityElement, data) {
    console.log(activityElement);

    activityElement.parentElement.querySelector(".task-container").innerHTML = `
      <ul class="list-group list-group-flush">
      ${data.tasks.map(task => `<li class="list-group-item">${task}</li><input type="hidden" name="activities[][tasks][]" value="${task}">`).join('')}
      </ul>
    `
  }

  fullDescription(data, ageRange, eventTitle) {
    const stepByStepInstructions = data.instructions.map((step, index) => `${index + 1}. ${step}`).join("<br><br>");
    return `
    <div class="card shadow-sm border-0 mb-4 activity-card" data-preview-event-target="activity" data-activity-title="${data.title}">
      <div class="card-body" data-controller="real-preview-event">
        <div class="d-flex justify-content-between align-items-center">
            <h4 class="card-title mb-0">
              ${data.title}
            </h4>
            <button
              data-action="click->real-preview-event#regenerate"
              data-activity-title="${data.title}"
              class="btn btn-link p-0 regenerate-btn"
              data-age-range="${ageRange}"
              data-event="${eventTitle}">
              <i class="fa-solid fa-arrows-rotate"></i>
            </button>
          </div>
          <p class="mb-1"><i class="fas fa-info-circle"></i> ${data.description.split("\n\n")[0].replace("**Description**: ", "")}</p>
          <button class="btn btn-link p-0" type="button" data-bs-toggle="collapse" data-bs-target="#${data.title.split(" ").join("-")}">
            <i class="fa-solid fa-circle-chevron-down"></i>
          </button>
          <div class="collapse mt-3" id="${data.title.split(" ").join("-")}">
            <p><strong>Step-by-Step Instructions:</strong></p>
            <p>${stepByStepInstructions}</p>
            <p><strong>Materials:</strong> ${data.materials}</p>
          </div>

          <!-- Hidden fields to preserve activity details -->
          <input type="hidden" name="activities[][title]" value="${data.title}">
          <input type="hidden" name="activities[][description]" value="${data.description}">
          <input type="hidden" name="activities[][genres]" value='["${data.genre}"]'>
          <input type="hidden" name="activities[][age]" value="${data.ageRange}">
        </div>
      </div>
    </div>
  `;
  }
}

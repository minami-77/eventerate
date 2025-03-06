import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="generate-activity-on-show-page"
export default class extends Controller {
  connect() {
  }

  async generateActivity() {
    const eventId = this.element.dataset.eventId;
    const eventTitle = this.element.dataset.eventTitle;
    const age = this.element.dataset.age;

    const response = await fetch(`/activities/new_activity_with_ai/${eventId}?event_title=${eventTitle}&age=${age}`)

    if (response.ok) {
      const data = await response.json();
      this.appendActivity(data);
      if (data.tasks) this.appendTasks(data);
    }
  }

  appendActivity(data) {
    const activityContainer = document.querySelector(".activity-container");
    const newActivityElement = this.createNewActivityElement(data);
    newActivityElement.innerHTML = this.generateActivityHtml(data);
    activityContainer.append(newActivityElement);
  }

  appendTasks(data) {
    const taskContainer = document.querySelector(".task-container");
  }

  generateActivityHtml(data) {
    return `
      <div class="card-pink">
        <div class="card-overview">
          <p class="text-center"><strong>${data.title}</strong></p>

          <div class="icon-container d-flex justify-content-between px-2">
            <div class="col-6 text-center">
              <button type="button" class="btn btn-gradient-oval p-2" data-bs-toggle="modal" data-bs-target="#activityModal-${data.activity_id}">See details</button>
            </div>

            

            <div class="col-6 text-center">
              <a href="/events/${this.element.dataset.eventId}/activities/${data.activity_id}" class="no-underline", data-turbo-method="delete">
                <i class="fa-solid fa-trash-can icon-red"></i>
              </a>
            </div>
          </div>

        </div>
      </div>
    `
  }

  generateTaskHtml(task) {

  }

  createNewActivityElement(data) {
    const newActivity = document.createElement("div");
    newActivity.classList.add("col-3");
    return newActivity;
  }
}

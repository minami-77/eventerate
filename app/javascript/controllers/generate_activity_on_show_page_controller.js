import { Controller } from "@hotwired/stimulus"

// Connects to activity-controller="generate-activity-on-show-page"
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
      const activity = data.activity;
      this.appendActivity(activity, data);
      if (activity.tasks) this.appendTasks(activity, data.taskIds);
    }
  }

  appendActivity(activity, data) {
    const activityContainer = document.querySelector(".activity-container");
    const newActivityElement = this.createNewActivityElement();
    newActivityElement.innerHTML = this.generateActivityHtml(activity, data);
    activityContainer.append(newActivityElement);
  }

  appendTasks(activity, taskIds) {
    const taskContainer = document.querySelector(".task-container");
    activity.tasks.forEach((task, index) => {
      const newTask = this.createNewTaskElement();
      newTask.innerHTML = this.generateTaskHtml(task, index, taskIds);
      taskContainer.append(newTask);
    })
  }

  generateActivityHtml(activity, data) {
    return `
      <div class="card-pink">
        <div class="card-overview">
          <p class="text-center"><strong>${activity.title}</strong></p>

          <div class="icon-container d-flex justify-content-between px-2">
            <div class="col-6 text-center">
              <button type="button" class="btn btn-gradient-oval p-2" activity-bs-toggle="modal" activity-bs-target="#activityModal-${activity.activity_id}">See details</button>
            </div>

            <%= render "activity_details" %>

            <div class="col-6 text-center">
              <a href="/events/${this.element.dataset.eventId}/activities/${data.activity_id}" class="no-underline", activity-turbo-method="delete">
                <i class="fa-solid fa-trash-can icon-red"></i>
              </a>
            </div>
          </div>

        </div>
      </div>
    `
  }

  generateTaskHtml(task, index, taskIds) {
    return `
      <div class="card-mint d-flex flex-column justify-content-between align-items-center pb-4 flex-grow-1" data-controller="assign-tasks">
        <div>
          <p class="text-center">${task.title}</p>
        </div>

        <div class="icon-container d-flex justify-content-between align-items-center px-2 w-75">
          <div class="d-flex flex-column text-center justify-content-center">
            <div class="position-relative" data-controller="update-tasks-users">
              <img class="avatar assigned-user-image position-relative" alt="collab-user" data-action="click->update-tasks-users#showDropdown" data-update-tasks-users-target="image" src="https://static-00.iconduck.com/assets.00/profile-default-icon-2048x2045-u3j7s5nj.png">


              <%= render "tasks_users_dropdown", task: task %>


              <div class="position-absolute assigned-user-text">
                <p class="mb-0"><small data-update-tasks-users-target="name">&nbsp;</small></p>
              </div>
            </div>
          </div>

          <div data-controller="assign-tasks", data-assign-tasks-task-id-value="${taskIds[index]}" class="d-flex align-items-center">
            <button data-action="click->assign-tasks#toggleComplete" class="btn d-flex align-items-center completion-button-container" >
              <i class="fa-solid fa-circle-check icon-not-complete" data-assign-tasks-target = "completeIcon"></i>
            </button>
          </div>

          <a data-turbo-method="delete" data-turbo-confirm="Delete this task?" class="d-flex h-100 align-items-center" href="/events/${this.element.dataset.eventId}/tasks/${taskIds[index]}">
            <i class="fa-solid fa-trash-can icon-red"></i>
          </a>
        </div>
      </div>
    `
  }

  createNewTaskElement() {
    const newTask = document.createElement("div");
    newTask.classList.add("col-3", "d-flex");
    return newTask;
  }

  createNewActivityElement() {
    const newActivity = document.createElement("div");
    newActivity.classList.add("col-3");
    return newActivity;
  }
}

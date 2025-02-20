import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assign-tasks"
export default class extends Controller {
  static targets = ["form", "titleInput"]
  connect() {
    console.log("AssignTasksController connected!");
  }
// Edit
  assign(){
    this.formTarget.classList.toggle("d-none");
}
// Create
  setTaskTitle(event) {
    console.log("setTaskTitle called");
    const taskTitle = event.currentTarget.dataset.task;
    console.log(taskTitle);
    this.titleInputTarget.value = taskTitle;
    console.log(this.titleInputTarget);
  }
}

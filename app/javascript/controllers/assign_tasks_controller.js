import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assign-tasks"
export default class extends Controller {
  static targets = ["form", "details","column", "titleInput"]
  connect() {
    console.log("AssignTasksController connected!");
  }
//Details
  showDetails(){
    this.strech();
    this.detailsTarget.classList.toggle("d-none");

  }
  strech(){
    console.log(this.columnTarget);
    this.columnTarget.classList.replace("col-3","col-6");
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

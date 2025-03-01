import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "completeIcon"]  // "details","column", "titleInput"

  // Pass JS task value from html
  static values = {
    taskId: Number
  }

  // Connects to data-controller="assign-tasks"
  connect() {
    console.log("AssignTasksController connected!");
  }

  // Change icon colour and status on DB
  toggleComplete(){
    console.log("This is task", this.taskIdValue);
    console.log(this.completeIconTarget);

    if (this.completeIconTarget.classList.contains("icon-complete")){
      this.completeIconTarget.classList.remove("icon-complete");
      this.completeIconTarget.classList.add("icon-not-complete");

      const requestDetails = {
        method: "PATCH",
        headers: {"Content-Type": "application/json"},
      }

      fetch(`/tasks/${this.taskIdValue}/incomplete`, requestDetails)
        .then(response => response.json())
        .then(data => console.log(data));

    } else{
      this.completeIconTarget.classList.remove("icon-not-complete");
      this.completeIconTarget.classList.add("icon-complete");

      const requestDetails = {
        method: "PATCH",
        headers: {"Content-Type": "application/json"},
      }

      fetch(`/tasks/${this.taskIdValue}/complete`, requestDetails)
        .then(response => response.json())
        .then(data => console.log(data));
    }
  }
  // routes
  // complete_task PATCH  /tasks/:id/complete(.:format) tasks#complete
  // incomplete_task PATCH  /tasks/:id/incomplete(.:format) tasks#incomplete
}








//Details
  // showDetails(){
  //   // this.strech();
  //   this.detailsTarget.classList.toggle("d-none");
  // }
  // strech(){
  //   console.log(this.columnTarget);
  //   this.columnTarget.classList.replace("col-3","col-6");
  // }

// // Edit
//   assign(){
//     this.formTarget.classList.toggle("d-none");
// }
// // Create
//   setTaskTitle(event) {
//     console.log("setTaskTitle called");
//     const taskTitle = event.currentTarget.dataset.task;
//     console.log(taskTitle);
//     this.titleInputTarget.value = taskTitle;
//     console.log(this.titleInputTarget);
//   }

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["formEditActivityTitle", "formEditActivityDescription"]

  connect() {
    console.log("EditActivitiesController connected!");
  }

  // Edit
  editActivityTitle(event){
    // const button = event.currentTarget;
    console.log("Edit button clicked!");
    // console.log(button);
    console.log(this.formEditActivityTitleTarget);
    this.formEditActivityTitleTarget.classList.toggle("d-none");
  }

  editActivityDescription(event){
    console.log("Edit button clicked!");
    this.formEditActivityDescriptionTarget.classList.toggle("d-none");
  }

}

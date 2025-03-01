import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["formEditActivity"]

  connect() {
    console.log("EditActivitiesController connected!");
  }

  // Edit
  editActivity(){
    this.formEditActivityTarget.classList.toggle("d-none");
  }

}

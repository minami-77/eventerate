import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="assign-tasks"
export default class extends Controller {
  static targets = ["form"]
  connect() {
  }
  assign(){
    this.formTarget.classList.toggle("d-none");
  }
}

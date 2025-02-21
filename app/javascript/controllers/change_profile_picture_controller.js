import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="change-profile-picture"
export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.inputTarget.addEventListener("change", () => {
      if (this.inputTarget.files.length > 0) this.submitForm();
    })
  }

  newProfilePicture() {
    this.inputTarget.click();
  }

  submitForm() {
    this.element.submit();
  }
}

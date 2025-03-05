import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remove-update-dropdown"
export default class extends Controller {
  connect() {
    document.addEventListener("click", (event) => this.closeDropdown(event.target));
  }

  closeDropdown(target) {
    // Checks if there is a dropdown active. Only non assigned user images trigger this function
    if (!target.classList.contains("assigned-user-image") && !target.closest(".tasks-users-dropdown")) {
      const currentActive = document.querySelector(".active-dropdown");
      if (currentActive) {
        currentActive.classList.remove("active-dropdown");
        currentActive.classList.add("d-none");
      }
    }
  }
}

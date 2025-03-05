import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="update-tasks-users"
export default class extends Controller {
  static targets = ["dropdown", "name", "image"];

  connect() {
  }

  showDropdown() {
    this.hideOtherDropdowns();
    this.addDropdown();
  }

  addDropdown() {
    if (this.dropdownTarget.classList.contains("active-dropdown")) {
      this.dropdownTarget.classList.add("d-none");
      this.dropdownTarget.classList.remove("active-dropdown");
    } else {
      this.dropdownTarget.classList.remove("d-none");
      this.dropdownTarget.classList.add("active-dropdown");
    }
  }

  hideOtherDropdowns() {
    document.querySelectorAll(".tasks-users-dropdown").forEach((dropdown) => {
      dropdown.classList.add("d-none");
    })
  }

  updateUser(event) {
    console.log("hi");


    this.updateFields(event.currentTarget);
  }

  updateFields(target) {
    const imageSrc = target.querySelector(".avatar").src;
    const firstName = target.querySelector(".tasks-users-dropdown-text").innerText.split(" ")[0];
    this.nameTarget.innerText = firstName;
    this.imageTarget.src = imageSrc;
  }
}

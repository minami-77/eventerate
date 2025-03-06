import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="update-tasks-users"
export default class extends Controller {
  static targets = ["dropdown", "name", "image"];

  connect() {
  }

  checkBottomOfDropdown() {
    const dropdownRect = this.dropdownTarget.getBoundingClientRect();
    const beyondLowest = dropdownRect.bottom > window.innerHeight;
    console.log(beyondLowest);

    if (beyondLowest) {
      this.dropdownTarget.classList.add("tasks-users-dropdown-above");
    } else {
      this.dropdownTarget.classList.remove("tasks-users-dropdown-above");
    }
  }

  showDropdown() {
    this.hideOtherDropdowns();
    this.addDropdown();
    // This function checks to see if the dropdown would be below the bottom div, and if so, positions it above the image instead
    this.checkBottomOfDropdown();
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
      dropdown.classList.remove("active-dropdown");
    })
  }

  async updateUser(event) {
    const userId = event.currentTarget.dataset.userId;
    const taskId = event.currentTarget.dataset.taskId;
    const response = await fetch("/update_tasks_users", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        user_id: userId,
        task_id: taskId,
      })
    });

    if (response.ok) {
      this.updateFields(event.target);
      this.hideOtherDropdowns();
    }
  }

  updateFields(target) {
    // Target container is needed, as there are issues with the event.currentTarget selecting that way
    const targetContainer = target.closest(".tasks-users-dropdown-select");

    // This is only to update the view on the frontend. The backend is updated and confirmed before the frontend updates
    const imageSrc = targetContainer.querySelector(".avatar").src;
    const firstName = targetContainer.querySelector(".tasks-users-dropdown-text").innerText.split(" ")[0];
    this.nameTarget.innerText = firstName;
    this.imageTarget.src = imageSrc;
  }
}

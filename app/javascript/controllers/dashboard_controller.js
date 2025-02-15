import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard"
export default class extends Controller {
  static targets = ["sidebar"]

  connect() {
    // This is used to remove the sidebar when the users
    // navigates using the browsers back and forward buttons
    // without this, the sidebar will persists and the user
    // cannot click on anything and must refresh the page.
    this.sidebarTarget.classList.remove("show")
    const backdrop = document.querySelector(".offcanvas-backdrop")
    if (backdrop != null) {
      backdrop.remove()
      console.log("removed backdrop")
    }
  }
}

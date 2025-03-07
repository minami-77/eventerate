import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user-dropdown"
export default class extends Controller {
  static targets = ["avatars", "dropdown", "user"]

  connect() {
  }

  toggle(event){
    this.avatarsTarget.classList.toggle("avatar_container_show")
  }

  select(event){
    this.avatarsTarget.classList.remove("avatar_container_show")

    this.dropdownTarget.value = event.currentTarget.getAttribute("data-user-id")
    this.userTarget.src = event.currentTarget.src
  }
}

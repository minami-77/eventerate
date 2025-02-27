import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="select-chats"
export default class extends Controller {
  static targets = ["chatCard"];

  connect() {
  }

  select() {
    const currentActiveChat = document.querySelector(".active-chat");
    if (currentActiveChat) currentActiveChat.classList.remove("active-chat");
    this.chatCardTarget.classList.add("active-chat");
  }
}

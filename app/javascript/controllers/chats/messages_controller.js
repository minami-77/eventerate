import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
  static targets = ["messages"];

  connect() {

    this.onLoad();
  }

  onLoad() {
    // Sets the starting view position of a chat at the bottom of it
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }
}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="messages"
export default class extends Controller {
  static targets = ["messages", "input"];

  connect() {
    this.onLoad();
  }

  onLoad() {
    // Sets the starting view position of a chat at the bottom of it
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }

  // scrollToBottom() {
  //   setTimeout(() => {
  //     this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  //   }, 50);
  // }

  submit() {
    setTimeout(() => {
      this.inputTarget.value = "";
      this.inputTarget.select();
    }, 10);
  }
}

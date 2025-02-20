import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-message"
export default class extends Controller {
  static targets = ["avatar"]

  connect() {
    const currentUserId = parseInt(document.body.dataset.currentUserId, 10);
    if (parseInt(this.element.dataset.messageUserId, 10) === currentUserId) {
      this.element.classList.add("align-self-end")
      this.element.scrollIntoView({ behavior: 'smooth' });
    } else {
      this.avatarTarget.classList.remove("d-none");
      // This is also needed to stop the width of the message bubble from getting too big
      this.element.classList.add("align-self-start");
    }
  }
}

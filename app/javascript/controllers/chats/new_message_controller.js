import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-message"
export default class extends Controller {
  connect() {
    const currentUserId = parseInt(document.body.dataset.currentUserId, 10);
    if (parseInt(this.element.dataset.messageUserId, 10) === currentUserId) {
      this.element.classList.add("align-self-end")
      this.element.scrollIntoView({ behavior: 'smooth' });
    }
  }
}

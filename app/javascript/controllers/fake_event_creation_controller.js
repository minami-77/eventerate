import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fake-event"
export default class extends Controller {
  connect() {
  }

  create(event) {
    if (this.element.action.includes(`events/preview_event`)) {
      event.preventDefault();
      this.element.querySelector('.create-event-submit-button').disabled = true;
      setTimeout(() => {
        this.element.submit();
      }, 3000);
    }
  }
}

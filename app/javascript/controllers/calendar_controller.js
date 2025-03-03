import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  sendDate(event) {
    const newDate = event.currentTarget.dataset.date;
    const updateEvent = new CustomEvent("datepicker:update", {
      detail: { date: newDate },
      bubbles: true
    });
    document.dispatchEvent(updateEvent);
  }
}

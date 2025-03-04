import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["modalBody"]
  sendDate(event) {
    const newDate = event.currentTarget.dataset.date;
    const updateEvent = new CustomEvent("datepicker:update", {
      detail: { date: newDate },
      bubbles: true
    });
    document.dispatchEvent(updateEvent);
  }

  loadTasks(event) {
    event.preventDefault();
    const eventIdsString = event.currentTarget.dataset.eventIds;
    const eventIds = eventIdsString ? eventIdsString.split(",").map(id => id.trim()) : [];

    fetch(`/tasks?event_ids=${eventIds.join(",")}`)
      .then(response => response.text())
      .then(html => {
        this.modalBodyTarget.innerHTML = html;
      })
      .catch(error => console.error("Error loading tasks:", error));
  }
}

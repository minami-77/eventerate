import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="real-preview-event"
export default class extends Controller {
  connect() {
  }

  async regenerate(event) {
    event.preventDefault();
    console.log(event.currentTarget);
    const ageRange = event.currentTarget.getAttribute("data-age-range");
    const eventTitle = event.currentTarget.getAttribute("data-event");
    const response = await fetch(`/regenerate_activity?age_range=${ageRange}&event_title=${eventTitle}`);
    const data = await response.json();
    this.replaceActivity(data);
  }

  replaceActivity(data) {
    
  }
}

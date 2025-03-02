import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  connect() {
  }

  // filterDate(event) {
  //   const date = event.target.closest(".calendar-day").dataset.date;
  //   window.location.href = `http://localhost:3000/dashboard?date=${date}`
  // }
}

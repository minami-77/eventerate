import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  // static values = {
  //   hasEvent: Boolean,
  //   eventId: Number
  // }

  // openModal() {
  //   if (this.hasEventValue) {
  //     const modalElement = document.getElementById("dateEventModal")
  //     if (modalElement) {
  //       const eventModal = new bootstrap.Modal(modalElement)
  //       eventModal.show()
  //     }
  //   }
  // }
  // filterDate(event) {
  //   const date = event.target.closest(".calendar-day").dataset.date;
  //   window.location.href = `http://localhost:3000/dashboard?date=${date}`
  // }
}

import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.initializeDatepicker();
    document.addEventListener("datepicker:update", this.handleDateUpdate.bind(this));
  }

  disconnect() {
    document.removeEventListener("datepicker:update", this.handleDateUpdate.bind(this));
  }

  initializeDatepicker() {
    this.fp = flatpickr(this.inputTarget, {
      inline: true,
      dateFormat: "Y-m-d",
      minDate: "today",
      onChange: this.onDateChange.bind(this)
    });
  }

  onDateChange(selectedDates, dateStr, instance) {
    // Trigger the change event to update the form
    this.inputTarget.dispatchEvent(new Event('change'));
  }

  handleDateUpdate(event) {
    const newDate = event.detail.date;
    console.log(newDate);
    if (this.fp && newDate) {
      this.fp.setDate(newDate, true);
    }
  }
}

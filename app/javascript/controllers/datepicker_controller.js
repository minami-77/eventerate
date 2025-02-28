import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.initializeDatepicker();
  }

  initializeDatepicker() {
    flatpickr(this.inputTarget, {
      inline: true,
      dateFormat: "Y-m-d",
      onChange: this.onDateChange.bind(this)
    });
  }

  onDateChange(selectedDates, dateStr, instance) {
    // Trigger the change event to update the form
    this.inputTarget.dispatchEvent(new Event('change'));
  }
}

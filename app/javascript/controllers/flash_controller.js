import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.classList.add("flash-fade-out");
      setTimeout(() => {
        this.element.remove();
      }, 2000);
    }, 3000);
  }
}

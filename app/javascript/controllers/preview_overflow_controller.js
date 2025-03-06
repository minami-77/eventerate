import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="preview-overflow"
export default class extends Controller {
  connect() {
    // This makes the scrollbar visible to avoid janky elements moving left when the scrollbar appears
    document.querySelector("body").classList.add("preview-scrollbar");
  }
}

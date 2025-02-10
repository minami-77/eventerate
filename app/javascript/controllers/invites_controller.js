import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invites"
export default class extends Controller {
  static targets = ["email"];

  connect() {
    this.element.addEventListener("submit", this.submitTokenValidation.bind(this));
  }

  async submitTokenValidation(event) {
    event.preventDefault();
    const params = this.getParams();
    params.email = this.emailTarget.value;
    const response = await fetch("verify_token", {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify(params)
    });
    if (!response.ok) {
      const data = await response.json();
      if (data.flash) {
        this.displayFlashMessage(data.flash);
      }
    }
  }

  getParams() {
    const urlParams = new URLSearchParams(window.location.search);
    const params = {};
    for (const [key, value] of urlParams) {
      params[key] = value;
    }
    return params;
  }

  displayFlashMessage(message) {
    const flashDiv = document.createElement('div');
    flashDiv.classList.add('alert', 'alert-danger');
    flashDiv.innerText = message;

    document.body.appendChild(flashDiv);
    setTimeout(() => flashDiv.remove(), 3000);
  }
}

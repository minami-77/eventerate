import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invites"
export default class extends Controller {
  static targets = ["invitesButton"];

  connect() {
    this.invitesButtonTargets.forEach((button) => {
      button.addEventListener("click", this.submitJoinRequest);
    });
  }

  async submitJoinRequest(event) {
    const response = await fetch("invite_result", {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ invite_result: event.target.innerText, org_id: document.getElementById("org-id").value })
    });
    if (response.ok) {
      window.location.href = "/";
    }
  }

}

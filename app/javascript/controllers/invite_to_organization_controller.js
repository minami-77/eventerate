import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invite-to-organization"
export default class extends Controller {
  static targets = ["email"];

  connect() {

  }

  async formSubmit(event) {
    event.preventDefault();

    const organizationId = this.getOrgId();

    const response = await fetch(`/invite_link?id=${organizationId}&email=${this.emailTarget.value}`);
    const data = await response.json();

    this.displayInvite(data.invite_url, event.target);
  }

  displayInvite(inviteUrl, form) {
    const inviteElement = document.createElement("p");
    inviteElement.innerText = inviteUrl;
    inviteElement.classList.add("text-center");
    form.append(inviteElement);
  }

  getOrgId() {
    const path = window.location.pathname;
    const parts = path.split("/");
    return parts[2]
  }
}

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
    inviteElement.classList.add("text-center", "card", "p-2", "my-2", "invite-url", "text-secondary");
    document.querySelector("#copyContainer").insertAdjacentElement("afterbegin", inviteElement);
    this.addEventListener(inviteElement, form)
  }

  getOrgId() {
    const path = window.location.pathname;
    const parts = path.split("/");
    return parts[2]
  }

  addEventListener(element, form) {
    element.addEventListener("click", () => {
      navigator.clipboard.writeText(element.innerText);
      this.successfullyCopiedText(form);
    })
  }

  successfullyCopiedText(form) {
    const text = document.createElement("p");
    text.classList.add("text-success", "text-center");
    text.innerText = "Successfully copied to clipboard";

    form.append(text);
  }
}

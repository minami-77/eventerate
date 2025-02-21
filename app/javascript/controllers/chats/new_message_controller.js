import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-message"
export default class extends Controller {
  static targets = ["avatar"]

  connect() {
    this.setPosition();
    this.chatOrder();
    this.getLastMessage();
  }

  setPosition() {
    const currentUserId = parseInt(document.body.dataset.currentUserId, 10);
    if (parseInt(this.element.dataset.messageUserId, 10) === currentUserId) {
      this.element.classList.add("align-self-end")
      this.element.scrollIntoView({ behavior: 'smooth' });
    } else {
      this.avatarTarget.classList.remove("d-none");
      // This is also needed to stop the width of the message bubble from getting too big
      this.element.classList.add("align-self-start");
    }
  }

  chatOrder() {
    this.setLastUpdated();
    const chats = this.sortChats();
    this.updateChatsOrder(chats);
  }

  setLastUpdated() {
    const lastUpdated = this.element.dataset.updated;
    const chatId = this.element.closest(".messages").dataset.chatId;
    const chat = document.querySelector(`.chat-link[data-chat-id="${chatId}"]`);
    chat.dataset.updated = lastUpdated;
  }

  sortChats() {
    const chats = Array.from(document.querySelectorAll(".chat-link"));
    chats.sort((a, b) => {
      const aDate = Date.parse(a.dataset.updated);
      const bDate = Date.parse(b.dataset.updated);
      return this.sortFunction(aDate, bDate);
    });
    return chats;
  }

  sortFunction(a, b) {
    if (a == b) {
      return 0;
    } else {
      return a > b ? -1 : 1;
    }
  }

  updateChatsOrder(chats) {
    const container = document.querySelector(".chats-container");
    container.innerHTML = "";
    chats.forEach((chat) => {
      container.append(chat);
    });
  }

  async getLastMessage() {
    const chatId = this.element.closest(".messages").dataset.chatId;
    const response = await fetch(`/chats/get_last_message?id=${chatId}`);
    const data = await response.json();
    const chat = document.querySelector(`.chat-link[data-chat-id="${chatId}"]`);
    chat.querySelector(".last-message-sender").innerText = `${data.first_name} said:`;
    chat.querySelector(".last-message").innerText = data.message;
    chat.querySelector(".last-message-time").innerText = this.parseDate(data.updated_at);
  }

  parseDate(time) {
    const date = new Date(time);

    const formattedDate = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} - ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}`;

    return formattedDate;
  }
}

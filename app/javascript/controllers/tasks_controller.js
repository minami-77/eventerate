import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tasks"
export default class extends Controller {
  toggleStatus(event) {
    event.preventDefault();
    const taskId = event.currentTarget.dataset.taskId;
    const icon = event.currentTarget.querySelector('i');
    const isCompleted = icon.classList.contains('text-success');
    const newStatus = !isCompleted;

    fetch(`/tasks/${taskId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('[name="csrf-token"]').getAttribute("content")
      },
      body: JSON.stringify({ task: { completed: newStatus } })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        if (data.task.completed) {
          icon.classList.remove('text-secondary');
          icon.classList.add('text-success');
        } else {
          icon.classList.remove('text-success');
          icon.classList.add('text-secondary');
        }
      } else {
        console.error("Error updating task:", data.error)
      }
    })
    .catch(error => console.error("Fetch error:", error));
  }
}

import { Controller } from "@hotwired/stimulus"


function displayFlash(message, type = 'success') {
  const flashDiv = document.createElement('div');
  flashDiv.classList.add('alert', `alert-${type}`);
  flashDiv.textContent = message;
  flashDiv.style.opacity = "1"; // Start fully opaque

  // Append flash message to a container or body
  const flashContainer = document.getElementById('flash-messages');
  if (flashContainer) {
    flashContainer.appendChild(flashDiv);
  } else {
    document.body.appendChild(flashDiv);
  }

  // After 3 seconds, initiate the fade out
  setTimeout(() => {
    flashDiv.style.transition = "opacity 1s";
    flashDiv.style.opacity = "0";
    // Remove the flash message after the transition completes
    setTimeout(() => {
      flashDiv.remove();
    }, 1000);
  }, 3000);
}
// Connects to data-controller="tasks"
export default class extends Controller {
  toggleStatus(event) {
    event.preventDefault();
    const taskId = event.currentTarget.dataset.taskId;
    const icon = event.currentTarget.querySelector('i');
    const isCompleted = icon.classList.contains('text-success');
    const newStatus = !isCompleted;

    fetch(`/tasks/${taskId}/update_from_modal`, {
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

        if (data.flash) {
          displayFlash(data.flash, 'success')
        }



        const completionRing = document.getElementById(`completion-${data.task.event_id}`);
        if (completionRing) {
          const updatedPercentage = parseFloat(data.updated_percentage.replace('%',''));
          const updatedProgress = Math.round((updatedPercentage / 100) * 360);
          completionRing.style.setProperty('--progress', `${updatedProgress}deg`);
          completionRing.setAttribute('data-percentage', data.updated_percentage);

        }


        const taskElement = document.querySelector(`.task-info[data-task-id="${taskId}"]`);
        if (taskElement) {
          if (data.task.completed) {
            taskElement.classList.add('d-none');
          } else {
            taskElement.classList.remove('d-none');
          }
        }

        const eventId = data.task.event_id;
        const badge = document.getElementById(`event-${eventId}`)
        if (badge) {
          if (data.unfinished_tasks_count === 0) {
            badge.classList.add('d-none');
          } else {
            badge.classList.remove('d-none');
          };
        }

        const taskList = document.getElementById(`task-list`)
        if (taskList) {
          if (data.unfinished_tasks_count === 0) {
            taskList.innerHTML = '<h3 class="text-center">Hurray! No Tasks 🎉🥳🎉</h3>'
          }
        }

      } else {
        console.error("Error updating task:", data.error)
      }
    })
    .catch(error => console.error("Fetch error:", error));
  }
}

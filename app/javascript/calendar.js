// Import FullCalendar and its styles
import { Calendar } from "fullcalendar"
import dayGridPlugin from "fullcalendar-daygrid"
import timeGridPlugin from "fullcalendar-timegrid"
import interactionPlugin from "fullcalendar-interaction"
import "fullcalendar-css"
import "fullcalendar-daygrid-css"
import "fullcalendar-timegrid-css"

document.addEventListener('turbolinks:load', function() {
  const calendarEl = document.getElementById('calendar');
  if (calendarEl) {
    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin],
      initialView: 'dayGridMonth',
      events: '/events.json',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      editable: false,
      eventDidMount: function(info) {
        const tooltip = new Tooltip(info.el, {
          title: info.event.title + '\n' + info.event.start.toISOString().slice(0, 10),
          placement: 'top',
          trigger: 'hover',
          container: 'body'
        });
      }
    });
    calendar.render();
  }
});

# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true

pin "fullcalendar", to: "https://cdn.jsdelivr.net/npm/@fullcalendar/core@5.10.1/main.min.js"
pin "fullcalendar-daygrid", to: "https://cdn.jsdelivr.net/npm/@fullcalendar/daygrid@5.10.1/main.min.js"
pin "fullcalendar-timegrid", to: "https://cdn.jsdelivr.net/npm/@fullcalendar/timegrid@5.10.1/main.min.js"
pin "fullcalendar-interaction", to: "https://cdn.jsdelivr.net/npm/@fullcalendar/interaction@5.10.1/main.min.js"
pin "fullcalendar-css", to: "https://cdn.jsdelivr.net/npm/@fullcalendar/core@5.10.1/main.min.css"
pin "fullcalendar-daygrid-css", to: "https://cdn.jsdelivr.net/npm/@fullcalendar/daygrid@5.10.1/main.min.css"
pin "fullcalendar-timegrid-css", to: "https://cdn.jsdelivr.net/npm/@fullcalendar/timegrid@5.10.1/main.min.css"

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sharing-card"
export default class extends Controller {
  static values = {
    path: String
  }

  connect() {
    console.log(`Hi from ${this.identifier}`)
    console.log(this.pathValue);
    console.log(document.querySelector("meta[name=csrf-token]").content)
  }

  join() {
    event.preventDefault();
    fetch(this.pathValue, {
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        Accept: 'application/json',
        "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content,
        credentials: "same-origin"
      }
    })
    .then(response => response.json())
    .then((data) => {
      this.element.outerHTML = data.sharing_card_html;
      // handle JSON response from server
    });
  }
}

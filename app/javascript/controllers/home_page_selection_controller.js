import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-page-selection"
export default class extends Controller {
  static targets = ["movieSuggestion", "movieSorties"]
  connect() {

  }
  updateContent() {
    console.log(this.movieSuggestionTarget.checked)
    console.log(this.movieSortiesTarget.checked)
  }

}

import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-page-selection"
export default class extends Controller {
  //ajouter un target sur mes deux containers : un pour suggestion et un pour sortie (par défaut sortie hidden)
  static targets = ["movieSuggestionInput", "movieSortiesInput", "movieSuggestionLabel", "movieSortiesLabel"]
  connect() {

  }
  updateContent() {
//ajouter un target sur mes deux containers : un pour suggestion et un pour sortie (par défaut sortie hidden)
// dans les conditions, dire que si c'est check, j'ajoute ou non la class hidden sur tout mon container ContainerSortieTarget...)

    if (this.movieSuggestionInputTarget.checked){
    this.movieSuggestionLabelTarget.classList.add("selected-movies-title")
    this.movieSortiesLabelTarget.classList.remove("selected-movies-title")

  }else {
    this.movieSuggestionLabelTarget.classList.remove("selected-movies-title")
    this.movieSortiesLabelTarget.classList.add("selected-movies-title")
    }
  }

}

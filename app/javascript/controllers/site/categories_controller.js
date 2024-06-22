import { Controller } from "@hotwired/stimulus";
import debounce from "debounce";

// Connects to data-controller="site--categories"
export default class extends Controller {
  initialize() {
    this.submitFilter = debounce(this.submitFilter.bind(this), 400);
  }

  submitFilter() {
    this.element.requestSubmit();
  }
}

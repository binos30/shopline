import { Controller } from "@hotwired/stimulus";
import debounce from "debounce";
import TurboProgressBar from "../../components/TurboProgressBar";

// Connects to data-controller="admin--table"
export default class extends Controller {
  initialize() {
    this.submitFilter = debounce(this.submitFilter.bind(this), 400);
    this.turboProgressBar = new TurboProgressBar();
  }

  connect() {
    // https://turbo.hotwired.dev/reference/events#turbo%3Abefore-fetch-request
    document.addEventListener("turbo:before-fetch-request", () => {
      this.turboProgressBar.show();
    });

    // https://turbo.hotwired.dev/reference/events#turbo%3Abefore-frame-render
    document.addEventListener("turbo:before-frame-render", () => {
      this.turboProgressBar.hide();
    });

    // https://turbo.hotwired.dev/reference/events#turbo%3Arender
    document.addEventListener("turbo:render", () => {
      this.turboProgressBar.hide();
    });
  }

  submitFilter() {
    this.element.requestSubmit();
  }
}

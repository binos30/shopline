import { Controller } from "@hotwired/stimulus";
import debounce from "debounce";
import TurboProgressBar from "../components/TurboProgressBar";

// Connects to data-controller="filter"
export default class extends Controller {
  initialize() {
    this.submitFilter = debounce(this.submitFilter.bind(this), 400);
    this.turboProgressBar = new TurboProgressBar();
  }

  connect() {
    // https://turbo.hotwired.dev/reference/events#turbo%3Abefore-fetch-request
    document.addEventListener("turbo:before-fetch-request", this.showProgressBar.bind(this), false);

    // https://turbo.hotwired.dev/reference/events#turbo%3Abefore-stream-render
    document.addEventListener("turbo:before-stream-render", this.hideProgressBar.bind(this), false);

    // https://turbo.hotwired.dev/reference/events#turbo%3Abefore-frame-render
    document.addEventListener("turbo:before-frame-render", this.hideProgressBar.bind(this), false);

    // https://turbo.hotwired.dev/reference/events#turbo%3Arender
    document.addEventListener("turbo:render", this.hideProgressBar.bind(this), false);
  }

  disconnect() {
    document.removeEventListener("turbo:before-fetch-request", this.showProgressBar.bind(this), false);
    document.removeEventListener("turbo:before-stream-render", this.hideProgressBar.bind(this), false);
    document.removeEventListener("turbo:before-frame-render", this.hideProgressBar.bind(this), false);
    document.removeEventListener("turbo:render", this.hideProgressBar.bind(this), false);
  }

  showProgressBar() {
    this.turboProgressBar.show();
  }

  hideProgressBar() {
    this.turboProgressBar.hide();
  }

  submitFilter() {
    this.element.requestSubmit();
  }
}

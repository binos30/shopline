/* eslint-disable no-undef */
export default class TurboProgressBar {
  constructor() {
    this.adapter = Turbo.navigator.delegate.adapter;
  }

  show() {
    this.adapter.formSubmissionStarted(this);
  }

  hide() {
    this.adapter.formSubmissionFinished(this);
  }
}

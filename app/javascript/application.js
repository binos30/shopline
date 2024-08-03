/* eslint-disable no-undef */
// Entry point for the build script in your package.json
import "@fortawesome/fontawesome-free/js/all.min";
import "@hotwired/turbo-rails";
import "./controllers";
import "flowbite/dist/flowbite.turbo.min";
import "trix";
import "@rails/actiontext";
import LocalTime from "local-time";

LocalTime.start();

/**
 * Turbo lets you define custom actions on top of the default actions that it provides (`append`, `replace`, `remove` etc).
 * If we were to respond with a turbo stream that knew how to “redirect”, then that might solve Turbo frame break out + redirect problem.
 * The first step is to tell Turbo what to do if a stream with the action “redirect” is received:
 *
 * `<turbo-stream url="url" action="redirect"><template></template></turbo-stream>`
 */
Turbo.StreamActions.redirect = function () {
  const url = this.getAttribute("url") || "/";
  Turbo.visit(url);
};

document.addEventListener("turbo:load", () => {
  const cart = JSON.parse(localStorage.getItem("cart"));
  const cartCountEl = document.getElementById("cart-count");
  if (cart?.length && cartCountEl) {
    cartCountEl.innerText = cart.length;
  }
});

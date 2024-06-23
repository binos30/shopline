// Entry point for the build script in your package.json
import "@fortawesome/fontawesome-free/js/all.min";
import "@hotwired/turbo-rails";
import "./controllers";
import "flowbite/dist/flowbite.turbo.min";

document.addEventListener("turbo:load", () => {
  const cart = JSON.parse(localStorage.getItem("cart"));
  const cartCountEl = document.getElementById("cart-count");
  if (cart?.length && cartCountEl) {
    cartCountEl.innerText = cart.length;
  }
});

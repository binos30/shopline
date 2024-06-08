import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="site--cart"
export default class extends Controller {
  initialize() {
    window.cart = JSON.parse(localStorage.getItem("cart"));
    const cart = window.cart;
    if (!cart) return;

    let total = 0;
    for (let i = 0; i < cart.length; i++) {
      const item = cart[i];
      const price = +item.price;
      total += price * item.quantity;

      const div = document.createElement("div");
      div.classList.add("mt-2");
      div.innerText = `Item: ${item.name} - ₱${price.toFixed(2)} - Size: ${item.size} - Qty: ${
        item.quantity
      }`;
      const deleteButton = document.createElement("button");
      deleteButton.innerText = "Remove";
      deleteButton.value = i;
      deleteButton.classList.add(
        "ml-2",
        "px-2",
        "py-1",
        "text-xs",
        "font-medium",
        "text-center",
        "text-white",
        "bg-red-600",
        "rounded-lg",
        "hover:bg-red-700",
        "focus:ring-4",
        "focus:outline-none",
        "focus:ring-red-300"
      );
      deleteButton.addEventListener("click", this.removeFromCart);
      div.appendChild(deleteButton);
      this.element.prepend(div);
    }
    const totalEl = document.createElement("div");
    totalEl.innerText = `Total: ₱${total.toFixed(2)}`;
    const totalContainer = document.getElementById("total");
    totalContainer.appendChild(totalEl);
  }

  removeFromCart(e) {
    const cart = window.cart;
    const index = e.target.value;
    cart.splice(index, 1);
    localStorage.setItem("cart", JSON.stringify(cart));
    window.location.reload();
  }

  clear() {
    localStorage.removeItem("cart");
    window.location.reload();
  }
}

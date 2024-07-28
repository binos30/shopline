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
      div.innerText = `Item: ${item.name} - $${price.toFixed(2)} - Size: ${item.size} - Qty: ${item.quantity}`;
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
        "focus:ring-red-300",
      );
      deleteButton.addEventListener("click", this.removeFromCart);
      div.appendChild(deleteButton);
      this.element.prepend(div);
    }
    const totalEl = document.createElement("div");
    totalEl.innerText = `Total: $${total.toFixed(2)}`;
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

  checkout() {
    const cart = window.cart;
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    const payload = {
      authenticity_token: "",
      cart,
    };

    fetch("/checkout", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify(payload),
    }).then((response) => {
      if (response.ok) {
        response.json().then((res) => (window.location.href = res.url));
      } else {
        response.json().then((res) => {
          // Check if response has login_path (means unauthorized) then redirect to login
          if (res.login_path) {
            window.location.href = res.login_path;
          } else {
            this.showError(
              `There was an error while processing your order: ${response.status} ${response.statusText} - ${res.error}`,
            );
          }
        });
      }
    });
  }

  showError(error) {
    const errorContainer = document.getElementById("errorContainer");
    const errorEl = document.createElement("div");

    // Check if errorContainer has children element then remove each element
    // to prevent duplicate error message when clicking Checkout button multiple times
    if (errorContainer.hasChildNodes()) {
      [...errorContainer.childNodes].forEach((el) => el.remove());
    }
    errorContainer.classList.add("p-4");
    errorEl.classList.add("text-sm", "font-medium");
    errorEl.innerText = error;
    errorContainer.appendChild(errorEl);
  }
}

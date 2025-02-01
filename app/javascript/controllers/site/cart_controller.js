import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="site--cart"
export default class extends Controller {
  initialize() {
    const productsContainer = this.element.querySelector("#products-container");
    const subtotalElement = document.getElementById("order-subtotal");
    const totalElement = document.getElementById("order-total");
    const orderSummaryContainer = document.getElementById("order-summary");
    window.cart = JSON.parse(localStorage.getItem("cart"));
    const cart = window.cart;

    // Check if productsContainer has children element then remove each element
    // to prevent duplicating of rendered element when clicking a link then clicking the browser back button
    if (productsContainer.hasChildNodes()) {
      [...productsContainer.childNodes].forEach((el) => el.remove());
    }
    if (!cart?.length) {
      productsContainer.insertAdjacentHTML("afterbegin", this.emptyCartContent());
      return;
    }

    orderSummaryContainer.classList.remove("hidden");

    let subtotal = 0;
    const shippingFee = 0;
    for (let i = 0; i < cart.length; i++) {
      const count = i + 1;
      const item = cart[i];
      const price = +item.price;
      subtotal += price * item.quantity;

      productsContainer.insertAdjacentHTML("afterbegin", this.productCard(item, count));

      const removeButton = document.getElementById(`remove-btn-${count}`);
      removeButton.value = i;
      removeButton.addEventListener("click", this.removeFromCart);
    }
    const total = subtotal + shippingFee;
    subtotalElement.innerText = `$${subtotal.toFixed(2)}`;
    totalElement.innerText = `$${total.toFixed(2)}`;

    this.initInputQuantity();
  }

  /**
   * Disconnects event listeners from quantity input elements and cleans up resources.
   *
   * This method iterates over all elements with the `data-input-quantity` attribute,
   * removes the click event listeners for increment and decrement buttons, and sets
   * the global `cart` object to `null` to prevent memory leaks.
   */
  disconnect() {
    this.element.querySelectorAll("[data-input-quantity]").forEach((targetEl) => {
      const targetId = targetEl.id;
      const incrementEl = this.element.querySelector('[data-input-quantity-increment="' + targetId + '"]');
      const decrementEl = this.element.querySelector('[data-input-quantity-decrement="' + targetId + '"]');
      let minValue = targetEl.getAttribute("data-input-quantity-min");
      let maxValue = targetEl.getAttribute("data-input-quantity-max");
      minValue = minValue ? parseInt(minValue) : null;
      maxValue = maxValue ? parseInt(maxValue) : null;

      incrementEl.removeEventListener("click", this.incrementClickHandler.bind(this, targetEl, maxValue), false);
      decrementEl.removeEventListener("click", this.decrementClickHandler.bind(this, targetEl, minValue), false);
    });
    window.cart = null;
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
    errorContainer.classList.add("p-3");
    errorEl.classList.add("text-sm", "font-medium");
    errorEl.innerText = error;
    errorContainer.appendChild(errorEl);
  }

  initInputQuantity() {
    this.element.querySelectorAll("[data-input-quantity]").forEach((targetEl) => {
      const targetId = targetEl.id;
      const incrementEl = this.element.querySelector('[data-input-quantity-increment="' + targetId + '"]');
      const decrementEl = this.element.querySelector('[data-input-quantity-decrement="' + targetId + '"]');
      let minValue = targetEl.getAttribute("data-input-quantity-min");
      let maxValue = targetEl.getAttribute("data-input-quantity-max");
      minValue = minValue ? parseInt(minValue) : null;
      maxValue = maxValue ? parseInt(maxValue) : null;

      incrementEl.addEventListener("click", this.incrementClickHandler.bind(this, targetEl, maxValue), false);
      decrementEl.addEventListener("click", this.decrementClickHandler.bind(this, targetEl, minValue), false);
    });
  }

  incrementClickHandler(targetEl, maxValue) {
    const quantity = this.getCurrentValue(targetEl);
    if (maxValue !== null && quantity >= maxValue) return;
    targetEl.value = (quantity + 1).toString();

    const itemSubtotalElement = document.getElementById(`${targetEl.id}-subtotal`);
    const subtotalElement = document.getElementById("order-subtotal");
    const totalElement = document.getElementById("order-total");
    const cart = window.cart;
    const { productId, productPrice, productSize } = targetEl.dataset;
    const foundIndex = cart.findIndex((item) => item.id === +productId && item.size === productSize);

    if (foundIndex >= 0) {
      cart[foundIndex].quantity = +cart[foundIndex].quantity + 1;
      localStorage.setItem("cart", JSON.stringify(cart));

      const subtotal = (+productPrice * +cart[foundIndex].quantity).toFixed(2);
      const orderSubtotal = (+subtotalElement.textContent.replace(/\$/g, "") + +productPrice).toFixed(2);
      itemSubtotalElement.innerText = `$${subtotal}`;
      subtotalElement.innerText = `$${orderSubtotal}`;
      totalElement.innerText = `$${orderSubtotal}`;
    }
  }

  decrementClickHandler(targetEl, minValue) {
    const quantity = this.getCurrentValue(targetEl);
    if (minValue !== null && quantity <= minValue) return;
    targetEl.value = (quantity - 1).toString();

    const itemSubtotalElement = document.getElementById(`${targetEl.id}-subtotal`);
    const subtotalElement = document.getElementById("order-subtotal");
    const totalElement = document.getElementById("order-total");
    const cart = window.cart;
    const { productId, productPrice, productSize } = targetEl.dataset;
    const foundIndex = cart.findIndex((item) => item.id === +productId && item.size === productSize);

    if (foundIndex >= 0) {
      cart[foundIndex].quantity = +cart[foundIndex].quantity - 1;
      localStorage.setItem("cart", JSON.stringify(cart));

      const subtotal = (+productPrice * +cart[foundIndex].quantity).toFixed(2);
      const orderSubtotal = (+subtotalElement.textContent.replace(/\$/g, "") - +productPrice).toFixed(2);
      itemSubtotalElement.innerText = `$${subtotal}`;
      subtotalElement.innerText = `$${orderSubtotal}`;
      totalElement.innerText = `$${orderSubtotal}`;
    }
  }

  getCurrentValue(targetEl) {
    return parseInt(targetEl.value) || 0;
  }

  emptyCartContent() {
    return `
      <div class="flex flex-col items-center justify-center gap-2">
        <p class="text-xl font-semibold text-gray-900 dark:text-white">
          Your cart is empty!
        </p>
        <a
          class="inline-flex items-center gap-2 text-sm font-medium text-primary-700 underline hover:no-underline dark:text-primary-500"
          href="/products"
        >
          Continue Shopping
          <svg aria-hidden="true" class="h-5 w-5" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M19 12H5m14 0-4 4m4-4-4-4"
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
            ></path>
          </svg>
        </a>
      </div>
    `;
  }

  productCard(product, count) {
    const subtotal = (+product.price * +product.quantity).toFixed(2);
    return `
      <div class="rounded-lg border border-gray-200 bg-white p-4 shadow-sm dark:border-gray-700 dark:bg-gray-800 md:p-6">
        <div class="space-y-4 md:flex md:items-center md:justify-between md:gap-6 md:space-y-0">
          <a href="/products/${product.slug}" class="shrink-0 md:order-1">
            <img
              class="h-20 w-20 object-cover object-center"
              src=${product.imageUrl}
              alt="product image"
            />
          </a>
          <label for="quantity-input-${count}" class="sr-only">Choose quantity:</label>
          <div class="flex items-center justify-between md:order-3 md:justify-end">
            <div class="flex items-center">
              <button
                type="button"
                id="decrement-button-${count}"
                data-input-quantity-decrement="quantity-input-${count}"
                class="inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-md border border-gray-300 bg-gray-100 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-100 dark:border-gray-600 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-700"
              >
                <svg
                  class="h-2.5 w-2.5 text-gray-900 dark:text-white"
                  aria-hidden="true"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 18 2"
                >
                  <path
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M1 1h16"
                  />
                </svg>
              </button>
              <input
                type="number"
                id="quantity-input-${count}"
                data-input-quantity
                data-input-quantity-min="1"
                data-input-quantity-max="10"
                data-product-id=${product.id}
                data-product-price=${product.price}
                data-product-size=${product.size}
                class="w-10 shrink-0 border-0 bg-transparent text-center text-sm font-medium text-gray-900 focus:outline-none focus:ring-0 dark:text-white [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
                value="${product.quantity}"
                required
              />
              <button
                type="button"
                id="increment-button-${count}"
                data-input-quantity-increment="quantity-input-${count}"
                class="inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-md border border-gray-300 bg-gray-100 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-100 dark:border-gray-600 dark:bg-gray-700 dark:hover:bg-gray-600 dark:focus:ring-gray-700"
              >
                <svg
                  class="h-2.5 w-2.5 text-gray-900 dark:text-white"
                  aria-hidden="true"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 18 18"
                >
                  <path
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 1v16M1 9h16"
                  />
                </svg>
              </button>
            </div>
            <div class="text-end md:order-4 md:w-32">
              <p class="text-base font-bold text-gray-900 dark:text-white" id="quantity-input-${count}-subtotal">$${subtotal}</p>
            </div>
          </div>
          <div class="w-full min-w-0 flex-1 space-y-4 md:order-2 md:max-w-md">
            <a href="/products/${product.slug}" class="text-base font-medium text-gray-900 hover:underline dark:text-white">
              ${product.name}
            </a>
            <div class="flex items-center gap-4">
              <span class="inline-flex items-center text-sm font-medium text-gray-500 dark:text-gray-400">
                Size: ${product.size}
              </span>
              <button
                type="button"
                class="inline-flex items-center text-sm font-medium text-red-600 hover:underline dark:text-red-500"
                id="remove-btn-${count}"
              >
                <svg
                  class="me-1.5 h-5 w-5"
                  aria-hidden="true"
                  xmlns="http://www.w3.org/2000/svg"
                  width="24"
                  height="24"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke="currentColor"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M6 18 17.94 6M18 18 6.06 6"
                  />
                </svg>
                Remove
              </button>
            </div>
          </div>
        </div>
      </div>
    `;
  }
}

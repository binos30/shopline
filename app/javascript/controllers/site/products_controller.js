import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="site--products"
export default class extends Controller {
  static values = { product: Object, size: String };

  addToCart() {
    if (!this.sizeValue) {
      alert("Please select size");
      return;
    }
    const cart = localStorage.getItem("cart");
    const cartCountEl = document.getElementById("cart-count");

    if (cart) {
      const cartArray = JSON.parse(cart);
      const foundIndex = cartArray.findIndex(
        (item) => item.id === this.productValue.id && item.size === this.sizeValue,
      );

      if (foundIndex >= 0) {
        cartArray[foundIndex].quantity = +cartArray[foundIndex].quantity + 1;
      } else {
        cartArray.push({
          id: this.productValue.id,
          name: this.productValue.name,
          price: this.productValue.price,
          size: this.sizeValue,
          quantity: 1,
          slug: this.productValue.slug,
          imageUrl: this.productValue.image_url,
        });
      }
      localStorage.setItem("cart", JSON.stringify(cartArray));
      cartCountEl.innerText = cartArray.length;
    } else {
      const cartArray = [];
      cartArray.push({
        id: this.productValue.id,
        name: this.productValue.name,
        price: this.productValue.price,
        size: this.sizeValue,
        quantity: 1,
        slug: this.productValue.slug,
        imageUrl: this.productValue.image_url,
      });
      localStorage.setItem("cart", JSON.stringify(cartArray));
      cartCountEl.innerText = cartArray.length;
    }
  }

  selectSize(e) {
    this.sizeValue = e.target.value;
    const selectedSizeEl = document.getElementById("selected-size");
    selectedSizeEl.innerText = `Selected size: ${this.sizeValue}`;

    const addToCartBtn = document.getElementById("addToCartBtn");
    if (addToCartBtn.hasAttribute("disabled")) {
      addToCartBtn.removeAttribute("disabled");
    }
  }
}

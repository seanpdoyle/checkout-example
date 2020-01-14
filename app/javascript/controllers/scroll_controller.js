import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    top: Number,
  }

  savePosition({ target }) {
    if (target.dataset.scrollPermanent) {
      this.topValue = document.scrollingElement.scrollTop
    }
  }

  restorePosition() {
    if (this.hasTopValue) {
      document.scrollingElement.scrollTo(0, this.topValue);

      this.topValue = null
    }
  }
}

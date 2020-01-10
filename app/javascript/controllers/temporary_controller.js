import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    delay: Number,
  }

  connect() {
    setTimeout(() => {
      this.element.remove()
    }, this.delayValue || 5000)
  }
}

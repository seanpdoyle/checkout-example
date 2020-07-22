import { Controller } from "stimulus"

export default class extends Controller {
  static classes = [
    "enabled",
  ]

  static targets = [
    "button",
    "input",
  ]

  connect() {
    for (const button of this.buttonTargets) {
      button.hidden = false
    }

    this.inputTarget.classList.add(this.enabledClass)
  }

  stepUp() {
    this.inputTarget.stepUp()
  }

  stepDown() {
    this.inputTarget.stepDown()
  }
}

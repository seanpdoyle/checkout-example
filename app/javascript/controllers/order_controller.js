import { Controller } from "stimulus"
import dialogPolyfill from "dialog-polyfill"

export default class extends Controller {
  static targets = [
    "dialog",
  ]

  connect() {
    dialogPolyfill.registerDialog(this.dialogTarget)
    this.dialogTarget.open = false

    if (this.element.open) {
      this.dialogTarget.showModal()
    }
  }

  toggleDialog(event) {
    const details = event.target

    if (details.open) {
      if (this.dialogTarget.open) {
        this.dialogTarget.close()
      } else {
        this.dialogTarget.showModal()
      }
    }
  }

  closeDetails(event) {
    this.element.open = false
  }
}

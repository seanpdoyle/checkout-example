import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    append: Boolean,
  }

  cloneChildren(event) {
    const { newBody } = event.data

    const newElement = newBody.querySelector("#" + this.element.id)

    if (newElement) {
      const innerHTML = newElement.innerHTML

      if (this.appendValue) {
        this.element.insertAdjacentHTML("beforeend", innerHTML)
      } else {
        this.element.innerHTML = innerHTML
      }
    }
  }
}

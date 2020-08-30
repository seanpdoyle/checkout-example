import { Controller } from "stimulus"

function reset(element) {
  element.innerHTML = ""
}

export default class extends Controller {
  static targets = [
    "error",
  ]

  static values = {
    validationMessages: Object,
    willValidate: Boolean,
  }

  connect() {
    if (this.willValidateValue) {
      for (const input of this.element.elements) {
        const errorElement = this.findErrorElement(input)
        const errorText = errorElement?.textContent

        if (errorText) {
          input.setCustomValidity(errorText.trim())
          input.reportValidity()
        }
      }
    }
  }

  reportValidity(event) {
    const input = event.target
    const element = this.findErrorElement(input)

    if (element) {
      reset(element)
    }

    input.reportValidity()
  }

  showErrors(event) {
    event.preventDefault()

    const input = event.target
    const element = this.findErrorElement(input)

    const validationMessages = Object.entries(this.validationMessagesValue)
    const [ _, customMessage ] = validationMessages.find(([ key ]) => input.validity[key]) || [ null, input.validationMessage ]

    if (element) {
      element.innerHTML = customMessage
    } else if (customMessage) {
      input.setCustomValidity(customMessage)
    }
  }

  clearErrors(event) {
    this.errorTargets.forEach(reset)
  }

  findErrorElement(input) {
    const errorId = input.getAttribute("aria-describedby") || ""

    return this.errorTargets.find(error => errorId.includes(error.id))
  }
}

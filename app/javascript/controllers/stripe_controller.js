import "form-request-submit-polyfill"
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "cardNumber",
    "cardNumberErrors",
    "cardExpiry",
    "cardExpiryErrors",
    "cardCvc",
    "cardCvcErrors",
    "paymentMethod",
  ]
  static values = {
    billingDetails: Object,
    clientSecret: String,
    publishableKey: String,
  }

  initialize() {
    this.stripe = Stripe(this.publishableKeyValue)
    this.elements = this.stripe.elements()

    this.cardExpiry = this.elements.create("cardExpiry")
    this.cardCvc = this.elements.create("cardCvc")
    this.cardNumber = this.elements.create("cardNumber", {showIcon: true})
  }

  connect() {
    this.cardExpiry.mount(this.cardExpiryTarget)
    this.cardCvc.mount(this.cardCvcTarget)
    this.cardNumber.mount(this.cardNumberTarget)
  }

  disconnect() {
    this.cardExpiry.unmount()
    this.cardCvc.unmount()
    this.cardNumber.unmount()
  }

  dispatch(eventName, { target = this.element, detail = {}, bubbles = true, cancelable = true } = {}) {
    const type = `${this.identifier}:${eventName}`
    const event = new CustomEvent(type, { detail, bubbles, cancelable })
    target.dispatchEvent(event)

    return event
  }

  clearErrors() {
    this.cardExpiryErrorsTarget.innerHTML = ""
    this.cardCvcErrorsTarget.innerHTML = ""
    this.cardNumberErrorsTarget.innerHTML = ""
  }

  renderError(event) {
    const { type, code, message } = event.detail
    let target = this.cardNumberErrorsTarget

    if (code.match(/expiry/i) || code.match(/expired/i)) {
      target = this.cardExpiryErrorsTarget
    } else if (code.match(/cvc/i)) {
      target = this.cardCvcErrorsTarget
    }

    if (["card_error", "validation_error"].includes(type)) {
      target.innerHTML = message
    }
  }

  async confirmCardPayment(event) {
    if (this.paymentMethodTarget.value) {
    } else {
      event.preventDefault()
      event.stopPropagation()

      const { paymentIntent, error } = await this.stripe.confirmCardPayment(
        this.clientSecretValue, {
          payment_method: {
            card: this.elements.getElement("cardNumber"),
            billing_details: this.billingDetailsValue,
          }
        }
      )

      if (paymentIntent) {
        this.paymentMethodTarget.value = paymentIntent.payment_method

        this.element.requestSubmit()
      } else {
        this.dispatch("error", { detail: error })
      }
    }
  }
}

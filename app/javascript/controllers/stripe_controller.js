import "form-request-submit-polyfill"
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "cardNumber",
    "cardExpiry",
    "cardCvc",
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

  async confirmCardPayment(event) {
    if (this.paymentMethodTarget.value) {
    } else {
      event.preventDefault()
      event.stopPropagation()

      const { paymentIntent } = await this.stripe.confirmCardPayment(
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
      }
    }
  }
}

import { Controller } from "stimulus"

export default class extends Controller {
  static classes = [
    "invalid",
  ]
  static targets = [
    "card",
    "errorMessage"
  ]

  connect() {
    this.stripe = Stripe(this.publishableKey)
    this.card = this.stripe.elements().create("card", {
      classes: {
        invalid: this.invalidClass,
      },
    })

    this.card.addEventListener("change", (event) => {
      this.cardTarget.dispatchEvent(
        new CustomEvent("payment:change", { bubbles: true, detail: event })
      )
    })

    this.card.mount(this.cardTarget)
  }

  async submitPayment(event) {
    const result = await this.stripe.confirmCardPayment(this.clientSecret, {
      payment_method: { card: this.card },
    })

    if (result.error) {
      this.errorMessageTarget.textContent = result.error.message
    } else if (result.paymentIntent.status === "succeeded") {
      this.element.requestSubmit()
    }
  }

  get publishableKey() {
    return this.data.get("stripePublishableKey")
  }

  get clientSecret() {
    return this.data.get("stripeClientSecret")
  }
}

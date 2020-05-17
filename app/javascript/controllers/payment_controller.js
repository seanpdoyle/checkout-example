import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "card",
    "paymentMethod",
  ]

  connect() {
    this.stripe = Stripe(this.publishableKey)
    this.card = this.stripe.elements().create("card")

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
      debugger
    } else if (result.paymentIntent.status === "succeeded") {
      this.paymentMethodTarget.value = result.paymentIntent.payment_method

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

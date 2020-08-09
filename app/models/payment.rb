class Payment < Order
  def stripe_publishable_key
    Rails.configuration.stripe.fetch(:publishable_key)
  end

  def stripe_payment_intent
    Stripe::PaymentIntent.create(amount: total_in_cents, currency: currency)
  end

  def currency
    "usd"
  end
end

class Payment < Order
  def stripe_publishable_key
    Rails.configuration.stripe.fetch(:publishable_key)
  end
end

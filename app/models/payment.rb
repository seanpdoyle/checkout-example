class Payment < Order
  def paid!
    transaction do
      line_items.each(&:paid!)
      update!(
        paid_at: Time.current,
        paid_in_cents: line_items.sum(&:price_in_cents)
      )
      becomes(Order)
    end
  end

  def stripe_publishable_key
    Rails.configuration.stripe.fetch(:publishable_key)
  end
end

class Payment < Shipment
  attr_accessor :stripe_payment_method

  validates :stripe_payment_intent_id, presence: true
  validate :stripe_payment_method_matches, {if: :stripe_payment_intent_id?}

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

  private

  def stripe_payment_method_matches
    if stripe_payment_intent.payment_method != stripe_payment_method
      errors.add(:stripe_payment_method, :invalid)
    end
  end
end

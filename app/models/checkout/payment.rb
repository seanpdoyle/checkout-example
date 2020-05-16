module Checkout
  class Payment < Order
    store_accessor :billing_address,
      :line1,
      :line2,
      :city,
      :state,
      :postal_code,
      :country,
      prefix: :billing

    validates :billing_line1, presence: { on: :finalization }
    validates :billing_city, presence: { on: :finalization }
    validates :billing_state, presence: { on: :finalization }
    validates :billing_postal_code, length: { is: 5, on: :finalization }
    validates :billing_country, presence: { on: :finalization }

    validates :stripe_payment_method_id, presence: {
      on: :finalization,
    }
    validates :stripe_payment_intent_id, presence: true

    def prepare_for_payment!
      if payment_intent.blank?
        new_payment_intent = Stripe::PaymentIntent.create(
          amount: line_items.total,
          currency: currency
        )
        update!(payment_intent: new_payment_intent)
      else
        Stripe::PaymentIntent.update(
          payment_intent.id,
          amount: line_items.total_in_cents
        )
      end
    end

    def payment_intent=(payment_intent)
      @payment_intent = payment_intent
      self.stripe_payment_intent_id = payment_intent.id
    end

    def payment_intent
      if stripe_payment_intent_id.present?
        @payment_intent ||= Stripe::PaymentIntent.retrieve(stripe_payment_intent_id)
      end
    end

    def stripe_publishable_key
      Rails.application.config_for(:stripe).fetch(:publishable_key)
    end
  end
end

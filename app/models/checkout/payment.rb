module Checkout
  class Payment < Order
    validates :stripe_payment_intent_id, presence: true
    validates :stripe_payment_intent_status, inclusion: {
      in: ["succeeded"],
      on: :charge,
    }

    def stripe_payment_intent_status
      stripe_payment_intent.status
    end

    def prepare_for_payment!
      if stripe_payment_intent.blank?
        payment_intent = Stripe::PaymentIntent.create(
          amount: line_items.total,
          currency: currency
        )
        update!(stripe_payment_intent: payment_intent)
      else
        Stripe::PaymentIntent.update(
<<<<<<< HEAD
          payment_intent.id,
          amount: line_items.total_in_cents
=======
          stripe_payment_intent.id,
          amount: line_items.total,
>>>>>>> 427cf3f... passing all tests!
        )
      end
    end

    def stripe_payment_intent=(stripe_payment_intent)
      @stripe_payment_intent = stripe_payment_intent
      self.stripe_payment_intent_id = stripe_payment_intent.id
    end

    def stripe_payment_intent
      if stripe_payment_intent_id.present?
        Stripe::PaymentIntent.retrieve(stripe_payment_intent_id)
      end
    end

    def stripe_publishable_key
      Rails.application.config_for(:stripe).fetch(:publishable_key)
    end
  end
end

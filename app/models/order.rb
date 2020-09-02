class Order < ApplicationRecord
  has_many :line_items
  has_many :books, through: :line_items

  validates :line_items, presence: true

  def total_in_cents
    line_items.total_in_cents
  end

  def total_in_dollars
    line_items.total_in_dollars
  end

  concerning :Shipment do
    included do
      with_options on: [:shipment, :payment] do
        validates :email, presence: true
        validates :name, presence: true
        validates :line1, presence: true
        validates :city, presence: true
        validates :state, presence: true
        validates :postal_code, presence: true, length: {minimum: 5}
      end

      def prepare_for_payment!
        stripe_payment_intent = Stripe::PaymentIntent.create(
          amount: total_in_cents,
          currency: currency
        )
        update!(stripe_payment_intent_id: stripe_payment_intent.id)
      end

      def stripe_payment_intent
        Stripe::PaymentIntent.retrieve(stripe_payment_intent_id)
      end
    end
  end

  concerning :Payment do
    included do
      attr_accessor :stripe_payment_method

      with_options on: :payment do
        validates :stripe_payment_intent_id, presence: true
        validate :stripe_payment_method_matches, if: :stripe_payment_intent_id?
      end

      def paid!
        transaction do
          line_items.each(&:paid!)
          assign_attributes(
            paid_at: Time.current,
            paid_in_cents: line_items.sum(&:price_in_cents)
          )
          save!(context: :payment)
        end
      end

      def paid?
        paid_at?
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
  end
end

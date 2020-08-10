class Order < ApplicationRecord
  has_many :line_items
  has_many :books, through: :line_items

  validates :line_items, presence: true

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

  def total_in_cents
    line_items.total_in_cents
  end

  def total_in_dollars
    line_items.total_in_dollars
  end
end

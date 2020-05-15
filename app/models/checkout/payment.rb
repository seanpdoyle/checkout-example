module Checkout
  class Payment < Order
    validates :billing_address, presence: { unless: :bill_with_shipping_address? }
  end
end

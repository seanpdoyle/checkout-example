module Checkout
  class Billing < Order
    validates :billing_address, presence: true
    validates_associated :billing_address
  end
end

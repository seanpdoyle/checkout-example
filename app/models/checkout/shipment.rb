module Checkout
  class Shipment < Order
    validates :shipping_address, presence: true
  end
end

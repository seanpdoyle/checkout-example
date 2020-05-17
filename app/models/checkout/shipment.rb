module Checkout
  class Shipment < Order
    validates :shipping_address, presence: true
    validates_associated :shipping_address
  end
end

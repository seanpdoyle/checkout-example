module Checkout
  class Shipment < Order
    validates :email, presence: true
    validates :shipping_address, presence: true
    validates_associated :shipping_address
  end
end

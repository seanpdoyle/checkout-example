module Checkout
  class Shipment < Order
    store_accessor :shipping_address,
      :line1,
      :line2,
      :city,
      :state,
      :postal_code,
      :country,
      prefix: :shipping

    validates :shipping_line1, presence: true
    validates :shipping_city, presence: true
    validates :shipping_state, presence: true
    validates :shipping_postal_code, length: { is: 5 }
    validates :shipping_country, presence: true
  end
end

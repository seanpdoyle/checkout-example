class Shipment < Order
  validates :email, presence: true
end

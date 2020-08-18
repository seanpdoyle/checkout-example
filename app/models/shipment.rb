class Shipment < Order
  validates :email, presence: true
  validates :name, presence: true
  validates :line1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true, length: {minimum: 5}
end

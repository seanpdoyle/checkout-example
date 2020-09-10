class Shipment < Order
  attribute :name, :string
  attribute :email, :string
  attribute :line1, :string
  attribute :line2, :string
  attribute :city, :string
  attribute :state, :string
  attribute :postal_code, :string
  attribute :country, :string, default: "US"
end

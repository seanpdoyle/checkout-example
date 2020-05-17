class Order < ApplicationRecord
  has_secure_token

  has_many :line_items
  has_many :books, through: :line_items

  attribute :billing_address, AddressType.new
  attribute :shipping_address, AddressType.new

  def total_in_dollars
    line_items.total_in_cents / 100
  end

  def currency
    "usd"
  end

  def finalized?
    becomes(Checkout::Payment).valid?
  end
end

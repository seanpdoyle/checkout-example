class Book < ApplicationRecord
  has_many :line_items

  def price_in_dollars
    price_in_cents / 100.0
  end
end

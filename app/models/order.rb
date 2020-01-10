class Order < ApplicationRecord
  has_secure_token

  has_many :line_items
  has_many :books, through: :line_items

  def total_in_dollars
    line_items.total_in_cents / 100
  end
end

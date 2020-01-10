class Order < ApplicationRecord
  has_many :line_items
  has_many :books, through: :line_items

  validates :line_items, presence: true

  def total_in_dollars
    line_items.total_in_dollars
  end
end

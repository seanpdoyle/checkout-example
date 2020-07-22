class LineItem < ApplicationRecord
  belongs_to :book
  belongs_to :order

  validates :quantity, numericality: {greater_than: -1}

  delegate_missing_to :book

  def self.total_in_cents
    joins(:book).sum { |line_item| line_item.price_in_cents }
  end

  def price_in_cents
    book.price_in_cents * quantity
  end

  def increment=(step)
    self.quantity = quantity + step.to_i
  end

  def increment
    1
  end
end

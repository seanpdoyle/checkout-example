class LineItem < ApplicationRecord
  belongs_to :book
  belongs_to :order

  delegate_missing_to :book

  def self.total
    joins(:book).sum("books.price_in_cents")
  end

  def increment=(step)
    self.quantity = quantity + step.to_i
  end

  def increment
    1
  end
end

class LineItem < ApplicationRecord
  belongs_to :book
  belongs_to :order

  validates :quantity, numericality: {greater_than_or_equal_to: 0}

  delegate_missing_to :book

  scope :for_cart, -> { order(created_at: :desc).includes(:book) }

  def increment=(step)
    self.quantity = quantity + step.to_i
  end

  def increment
    1
  end
end

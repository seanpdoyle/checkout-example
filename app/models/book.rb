class Book < ApplicationRecord
  has_many :line_items

  has_rich_text :description
  has_rich_text :table_of_contents

  has_one_attached :cover

  def price_in_dollars
    price_in_cents / 100.0
  end
end

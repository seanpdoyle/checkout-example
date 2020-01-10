class Book < ApplicationRecord
  has_many :line_items

  has_rich_text :description
  has_rich_text :table_of_contents

  has_one_attached :cover
end

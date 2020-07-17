require "test_helper"

class BookTest < ActiveSupport::TestCase
  test "#price_in_dollars transforms price in cents to dollars" do
    book = Book.new(price_in_cents: 10_50)

    price_in_dollars = book.price_in_dollars

    assert_equal 10.5, price_in_dollars
  end
end

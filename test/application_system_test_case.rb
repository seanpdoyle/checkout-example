require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::Helpers::NumberHelper

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def assert_book(book)
    assert_text book.title
    assert_text number_to_currency(book.price_in_cents / 100.0)
  end
end

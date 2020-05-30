require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper
  include ActionMailer::TestHelper

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def cart
    find("details", text: translate("layouts.application.order"), visible: :all)
  end

  def assert_book(book)
    assert_text book.title
    assert_text number_to_currency(book.price_in_cents / 100.0)
  end

  def assert_no_book(book)
    assert_no_text book.title
    assert_no_text number_to_currency(book.price_in_cents / 100.0)
  end

  def assert_total(*prices)
    number_to_currency(prices.sum)
  end
end

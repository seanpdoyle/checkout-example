require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  def with_wait_time(seconds: Capybara.default_max_wait_time)
    default = Capybara.default_max_wait_time

    Capybara.default_max_wait_time = seconds

    yield
  ensure
    Capybara.default_max_wait_time = default
  end

  def expand_cart
    sleep 1
    cart.tap(&:click)
  end

  def cart
    find("details", text: translate("layouts.application.order"), visible: :all)
  end

  def assert_book(book, quantity: 1)
    assert_text book.title
    assert_text number_to_currency(book.price_in_dollars * quantity)
  end

  def assert_no_book(book)
    assert_no_text book.title
    assert_no_text number_to_currency(book.price_in_dollars)
  end

  def assert_total(*prices)
    assert_text number_to_currency(prices.sum)
  end
end

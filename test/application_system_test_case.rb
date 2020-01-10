require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def expand_cart(&block)
    open_text = translate("application.navigation.order.open")
    disclosure = find("details:not([open]) summary", text: open_text)

    sleep 1
    disclosure.click

    if block_given?
      within_cart(&block)
    end
  end

  def within_cart(&block)
    within("details[open]", text: translate("orders.order.title"), &block)
  end

  def submit(i18n_key)
    translate(:create, scope: [:helpers, :submit, i18n_key])
  end

  def assert_book(book)
    assert_text book.title
    assert_text number_to_currency(book.price_in_dollars)
  end
end

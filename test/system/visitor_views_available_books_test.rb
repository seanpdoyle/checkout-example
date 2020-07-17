require "application_system_test_case"

class VisitorViewsAvailableBooksTest < ApplicationSystemTestCase
  include ActionView::Helpers::NumberHelper

  test "visitor views available books" do
    ruby_science = books(:ruby_science)
    maybe_haskell = books(:maybe_haskell)

    visit root_path

    assert_book ruby_science
    assert_book maybe_haskell
  end

  def assert_book(book)
    assert_text book.title
    assert_text number_to_currency(book.price_in_cents / 100.0)
  end
end

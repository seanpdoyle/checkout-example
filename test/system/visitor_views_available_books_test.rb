require "application_system_test_case"

class VisitorViewsAvailableBooksTest < ApplicationSystemTestCase
  test "visitor views available books" do
    ruby_science = books(:ruby_science)
    maybe_haskell = books(:maybe_haskell)

    visit root_path

    assert_book ruby_science
    assert_book maybe_haskell
  end
end

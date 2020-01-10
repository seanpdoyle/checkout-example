require "application_system_test_case"

class VisitorIncrementsBookQuantityFromCartTest < ApplicationSystemTestCase
  test "visitor increments book quantity from cart" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    click_on translate("helpers.submit.line_item.create")
    expand_cart
    within cart { click_on translate("helpers.submit.line_item.increment") }

    within cart { assert_book ruby_science, quantity: 2 }
  end
end

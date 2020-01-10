require "application_system_test_case"

class VisitorDecrementsBookQuantityFromCartTest < ApplicationSystemTestCase
  test "visitor decrements book quantity from cart" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    2.times { click_on translate("helpers.submit.line_item.create") }
    expand_cart
    within cart { click_on translate("helpers.submit.line_item.decrement") }

    within cart { assert_book ruby_science, quantity: 1 }
  end
end

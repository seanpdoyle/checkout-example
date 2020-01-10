require "application_system_test_case"

class VisitorDecrementsBookQuantityFromCartTest < ApplicationSystemTestCase
  test "visitor decrements book quantity from cart" do
    ruby_science = books(:ruby_science)

    add_to_cart ruby_science, increment: 2
    expand_cart { click_on submit(:line_item, :decrement) }

    within_cart do
      assert_book ruby_science, quantity: 1
    end
  end
end

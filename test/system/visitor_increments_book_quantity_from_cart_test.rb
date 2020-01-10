require "application_system_test_case"

class VisitorIncrementsBookQuantityFromCartTest < ApplicationSystemTestCase
  test "visitor increments book quantity from cart" do
    ruby_science = books(:ruby_science)

    add_to_cart ruby_science
    expand_cart { click_on submit(:line_item, :increment) }

    within_cart do
      assert_book ruby_science, quantity: 2
    end
  end
end

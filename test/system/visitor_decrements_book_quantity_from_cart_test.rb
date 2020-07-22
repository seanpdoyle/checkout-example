require "application_system_test_case"

class VisitorDecrementsBookQuantityFromCartTest < ApplicationSystemTestCase
  test "visitor decrements book quantity from cart" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    2.times { click_on submit(:line_item) }
    expand_cart { click_on submit(:line_item, :decrement) }

    expand_cart do
      assert_book ruby_science, quantity: 1
    end
  end
end

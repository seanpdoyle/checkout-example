require "application_system_test_case"

class VisitorDecrementsBookQuantityFromCartTest < ApplicationSystemTestCase
  test "visitor decrements book quantity from cart" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    click_on translate("helpers.submit.line_item.create")
    click_on translate("helpers.submit.line_item.create")
    cart.click
    click_on translate("helpers.submit.line_item.decrement")
    cart.click

    within cart do
      assert_book ruby_science, quantity: 1
    end
  end
end

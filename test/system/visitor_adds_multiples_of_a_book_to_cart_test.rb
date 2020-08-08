require "application_system_test_case"

class VisitorAddsMultiplesOfABookToCartTest < ApplicationSystemTestCase
  test "visitor adds a Book multiple times to the cart" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    3.times { click_on translate("helpers.submit.line_item.increment") }
    2.times { click_on translate("helpers.submit.line_item.decrement") }
    click_on translate("helpers.submit.line_item.create")
    expand_cart

    within cart do
      assert_book ruby_science, quantity: 2
      assert_total ruby_science.price_in_dollars * 2
    end
  end

  test "visitor adds a quantity of Books to the cart" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    fill_in translate("helpers.label.line_item.increment"), with: 3
    click_on translate("helpers.submit.line_item.create")
    expand_cart

    within cart do
      assert_book ruby_science, quantity: 3
      assert_total ruby_science.price_in_dollars * 3
    end
  end
end

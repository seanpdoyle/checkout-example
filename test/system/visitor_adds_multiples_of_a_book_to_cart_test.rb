require "application_system_test_case"

class VisitorAddsMultiplesOfABookToCartTest < ApplicationSystemTestCase
  test "visitor adds multiples of a book to cart" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    3.times { click_on translate("helpers.submit.line_item.increment") }
    2.times { click_on translate("helpers.submit.line_item.decrement") }
    click_on translate("helpers.submit.line_item.create")
    expand_cart

    within cart do
      assert_book ruby_science
      assert_total ruby_science.price_in_dollars * 2
    end
  end
end

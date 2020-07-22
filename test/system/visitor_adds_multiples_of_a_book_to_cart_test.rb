require "application_system_test_case"

class VisitorAddsMultiplesOfABookToCartTest < ApplicationSystemTestCase
  test "visitor adds multiples of a book to cart" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    4.times { click_on "Add one" }
    2.times { click_on "Remove one" }
    click_on translate("helpers.submit.line_item.create")
    cart.click

    within cart do
      assert_book ruby_science
      assert_total ruby_science.price_in_dollars * 2
    end
  end
end

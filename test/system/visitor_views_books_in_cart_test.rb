require "application_system_test_case"

class VisitorViewsBooksInCartTest < ApplicationSystemTestCase
  test "visitor views Books in their Cart" do
    ruby_science = books(:ruby_science)
    testing_rails = books(:testing_rails)
    order = orders(:rails)

    visit root_path(as: order)
    cart.click

    within cart do
      assert_book ruby_science
      assert_book testing_rails
      assert_total ruby_science.price_in_dollars, testing_rails.price_in_dollars
    end
  end
end

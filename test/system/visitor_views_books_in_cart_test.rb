require "application_system_test_case"

class VisitorViewsBooksInCartTest < ApplicationSystemTestCase
  test "visitor views Books in their Cart" do
    ruby_science = books(:ruby_science)
    testing_rails = books(:testing_rails)

    add_to_cart ruby_science
    add_to_cart testing_rails

    expand_cart do
      assert_book ruby_science
      assert_book testing_rails
      assert_total ruby_science.price_in_dollars, testing_rails.price_in_dollars
    end
  end

  def add_to_cart(book)
    visit book_path(book)
    click_on submit(:line_item)
  end

  def assert_total(*prices)
    assert_text number_to_currency(prices.sum)
  end
end

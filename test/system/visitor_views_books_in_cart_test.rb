require "application_system_test_case"

class VisitorViewsBooksInCartTest < ApplicationSystemTestCase
  test "visitor views Books in their Cart" do
    ruby_science = books(:ruby_science)
    testing_rails = books(:testing_rails)

    visit book_path(ruby_science)
    click_on translate("helpers.submit.line_item.create")
    click_on translate("books.show.library")
    click_on testing_rails.title
    click_on translate("helpers.submit.line_item.create")

    within expand_cart do
      assert_book ruby_science
      assert_book testing_rails
      assert_total ruby_science.price_in_dollars, testing_rails.price_in_dollars
    end
  end

  def assert_total(*prices)
    assert_text number_to_currency(prices.sum)
  end
end

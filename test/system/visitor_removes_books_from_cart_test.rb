require "application_system_test_case"

class VisitorRemovesBooksFromCartTestTest < ApplicationSystemTestCase
  test "visitor removes books from cart test" do
    ruby_science = books(:ruby_science)
    testing_rails = books(:testing_rails)

    add_to_cart ruby_science
    add_to_cart testing_rails
    expand_cart do
      click_on translate("orders.order.remove", book: ruby_science.title)
    end

    assert_text removed_book_flash(ruby_science)
    within_cart do
      assert_no_book ruby_science
      assert_book testing_rails
      assert_total testing_rails.price_in_dollars
    end
  end

  def removed_book_flash(book)
    translate(:notice, title: book.title, scope: "line_items.destroy")
  end
end

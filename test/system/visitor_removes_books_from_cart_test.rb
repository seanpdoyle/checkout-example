require "application_system_test_case"

class VisitorRemovesBooksFromCartTestTest < ApplicationSystemTestCase
  test "visitor removes books from cart test" do
    ruby_science = books(:ruby_science)
    testing_rails = books(:testing_rails)

    visit book_path(ruby_science)
    click_on add_to_cart
    click_on translate("books.show.library")
    click_on testing_rails.title
    click_on add_to_cart
    expand_cart
    click_on translate("orders.order.remove", book: ruby_science.title)

    assert_text removed_book_flash(ruby_science)
    within expand_cart do
      assert_no_book ruby_science
      assert_book testing_rails
      assert_total testing_rails.price_in_dollars
    end
  end

  def removed_book_flash(book)
    translate(:notice, title: book.title, scope: "line_items.destroy")
  end

  def add_to_cart
    translate("helpers.submit.line_item.create")
  end
end

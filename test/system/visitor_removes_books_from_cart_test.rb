require "application_system_test_case"

class VisitorRemovesBooksFromCartTestTest < ApplicationSystemTestCase
  test "visitor removes books from cart test" do
    ruby_science = books(:ruby_science)
    testing_rails = books(:testing_rails)

    visit root_path
    click_on ruby_science.title
    click_on add_to_cart
    click_on translate("books.show.library")
    click_on testing_rails.title
    click_on add_to_cart
    cart.click
    click_on translate("orders.order.remove", book: ruby_science.title)
    cart.click

    assert_text removed_book_flash(ruby_science)
    within cart do
      assert_book testing_rails
      assert_no_book ruby_science
      assert_total ruby_science.price_in_dollars
    end
  end

  def removed_book_flash(book)
    translate(:notice, title: book.title, scope: "line_items.destroy")
  end

  def add_to_cart
    translate("helpers.submit.line_item.create")
  end
end

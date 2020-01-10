require "application_system_test_case"

class VisitorAddsBookToCartTest < ApplicationSystemTestCase
  test "visitor adds a Book to their Cart" do
    ruby_science = books(:ruby_science)

    visit root_path
    click_on ruby_science.title
    click_on translate("helpers.submit.line_item.create")

    assert_text added_book_flash(ruby_science)
    within expand_cart { assert_book ruby_science }
  end

  def added_book_flash(book)
    translate("line_items.create.notice", title: book.title)
  end
end

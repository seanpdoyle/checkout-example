require "application_system_test_case"

class VisitorAddsBookToCartTest < ApplicationSystemTestCase
  test "visitor adds a Book to their Cart" do
    book = books(:ruby_science)

    visit root_path
    click_on book.title
    click_on translate(:create, scope: "helpers.submit.line_item")

    assert_text added_book_flash(book)
  end

  def added_book_flash(book)
    translate("line_items.create.notice", title: book.title)
  end
end

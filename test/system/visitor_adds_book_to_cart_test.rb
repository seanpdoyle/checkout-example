require "application_system_test_case"

class VisitorAddsBookToCartTest < ApplicationSystemTestCase
  test "visitor adds a Book to their Cart" do
    ruby_science = books(:ruby_science)

    visit root_path
    click_on ruby_science.title
    click_on translate("helpers.submit.line_item.create")

    assert_text added_book_flash(ruby_science)
    expand_cart do
      assert_book ruby_science
    end
  end

  def added_book_flash(book)
    translate("line_items.create.notice", title: book.title)
  end

  def expand_cart(&block)
    open_text = translate("application.navigation.order.open")
    disclosure = find("details:not([open]) summary", text: open_text)

    disclosure.click

    if block_given?
      within_cart(&block)
    end
  end

  def within_cart(&block)
    within("details[open]", text: translate("orders.order.title"), &block)
  end
end

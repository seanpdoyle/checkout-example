require "application_system_test_case"

class VisitorAddsMultiplesOfABookToCartTest < ApplicationSystemTestCase
  test "visitor adds a Book multiple times to the cart" do
    ruby_science = books(:ruby_science)

    add_to_cart ruby_science, increment: 3
    expand_cart do
      click_on submit(:line_item, :decrement)
    end

    expand_cart do
      assert_book ruby_science, quantity: 2
      assert_total ruby_science.price_in_dollars * 2
    end
  end

  test "visitor adds a quantity of Books to the cart" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    fill_in label(:line_item, :increment), with: 3
    click_on submit(:line_item)

    expand_cart do
      assert_book ruby_science, quantity: 3
      assert_total ruby_science.price_in_dollars * 3
    end
  end
end

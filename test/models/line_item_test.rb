require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  test ".total_in_cents sums the price of each book" do
    order = orders(:empty)
    ruby_science = books(:ruby_science)
    testing_rails = books(:testing_rails)
    order.update!(line_items: [
      LineItem.new(book: ruby_science, quantity: 1),
      LineItem.new(book: testing_rails, quantity: 1)
    ])

    total_in_cents = order.line_items.total_in_cents

    assert_equal ruby_science.price_in_cents + testing_rails.price_in_cents, total_in_cents
  end

  test ".total_in_cents sums the price of each book based on its quantity" do
    order = orders(:empty)
    ruby_science = books(:ruby_science)
    testing_rails = books(:testing_rails)
    order.update!(line_items: [
      LineItem.new(book: ruby_science, quantity: 1),
      LineItem.new(book: testing_rails, quantity: 2)
    ])

    total_in_cents = order.line_items.total_in_cents

    assert_equal(
      ruby_science.price_in_cents + (testing_rails.price_in_cents * 2),
      total_in_cents
    )
  end

  test "#increment= increments the quantity with a positive number" do
    line_item = LineItem.new(quantity: 0)

    line_item.increment = "1"

    assert_equal 1, line_item.quantity
  end

  test "#increment= decrements the quantity with a negative number" do
    line_item = LineItem.new(quantity: 2)

    line_item.increment = "-1"

    assert_equal 1, line_item.quantity
  end

  test "validates quantity is not negative" do
    line_item = LineItem.new(quantity: -1)

    valid = line_item.validate

    assert_not valid
    assert_includes line_item.errors, :quantity
  end
end

require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  test "invalid with a negative quantity" do
    line_item = LineItem.new(quantity: -1)

    valid = line_item.validate

    assert_not valid
    assert_includes line_item.errors, :quantity
  end

  test ".total_in_cents sums the price of each book" do
    ruby_science, testing_rails = books(:ruby_science, :testing_rails)
    order = Order.create!(line_items: [
      ruby_science.line_items.new(quantity: 1),
      testing_rails.line_items.new(quantity: 1)
    ])

    total_in_cents = order.line_items.total_in_cents

    assert_equal ruby_science.price_in_cents + testing_rails.price_in_cents, total_in_cents
  end

  test ".total_in_cents sums the price of each book based on its quantity" do
    ruby_science, testing_rails = books(:ruby_science, :testing_rails)
    order = Order.create!(line_items: [
      ruby_science.line_items.new(quantity: 1),
      testing_rails.line_items.new(quantity: 2)
    ])

    total_in_cents = order.line_items.total_in_cents

    assert_equal(
      ruby_science.price_in_cents + (testing_rails.price_in_cents * 2),
      total_in_cents
    )
  end

  test ".total_in_dollars translates the price in cents to dollars" do
    ruby_science = books(:ruby_science)
    order = Order.create!(line_items: [
      ruby_science.line_items.new(quantity: 1)
    ])

    total_in_dollars = order.line_items.total_in_dollars

    assert_equal(ruby_science.price_in_dollars, total_in_dollars)
  end

  test "#price_in_cents multiplies the price of the Book by its quantity" do
    ruby_science = books(:ruby_science)
    line_item = LineItem.new(book: ruby_science, quantity: 3)

    price_in_cents = line_item.price_in_cents

    assert_equal ruby_science.price_in_cents * 3, price_in_cents
  end
end

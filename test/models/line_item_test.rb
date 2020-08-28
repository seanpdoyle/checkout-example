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

  test "#paid? returns false when paid_at is nil" do
    line_item = LineItem.new(paid_at: nil)

    assert_not_predicate line_item, :paid?
  end

  test "#paid? returns true when paid_at is set" do
    line_item = LineItem.new(paid_at: 1.day.ago)

    assert_predicate line_item, :paid?
  end

  test "#paid! sets the paid_at column to now" do
    freeze_time do
      line_item = line_items(:ruby_science_rails)

      line_item.paid!

      assert_equal Time.current, line_item.paid_at
    end
  end

  test "#paid! sets the paid_in_cents column to the final total" do
    line_item = line_items(:ruby_science_rails)
    ruby_science = line_item.book

    line_item.paid!

    assert_equal ruby_science.price_in_cents * line_item.quantity, line_item.paid_in_cents
  end
end

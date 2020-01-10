require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "invalid without LineItem records" do
    order = Order.new

    valid = order.validate

    assert_not valid
    assert_includes order.errors, :line_items
  end
end

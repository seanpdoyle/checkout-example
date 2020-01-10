require "test_helper"

class LineItemTest < ActiveSupport::TestCase
  test "invalid with a negative quantity" do
    line_item = LineItem.new(quantity: -1)

    valid = line_item.validate

    assert_not valid
    assert_includes line_item.errors, :quantity
  end
end

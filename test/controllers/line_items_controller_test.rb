require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  test "#create without an existing Order creates a new Order" do
    ruby_science = books(:ruby_science)

    assert_created_order do
      post book_line_items_path(ruby_science), params: {
        line_item: {increment: 1}
      }
    end
    current_order = Order.last

    assert_equal cookies[:order_token], current_order.token, "stores Order token in cookie"
    assert_line_item current_order, ruby_science
  end

  test "#create with an existing Order re-uses the Order" do
    ruby_science = books(:ruby_science)
    current_order = orders(:empty)
    cookies[:order_token] = current_order.token

    assert_no_created_order do
      post book_line_items_path(ruby_science), params: {
        line_item: {increment: 1}
      }
    end

    assert_equal cookies[:order_token], current_order.token, "does not override the cookie"
    assert_line_item current_order, ruby_science
  end

  test "#create with an existing LineItem in the current Order increases the quantity" do
    ruby_science = books(:ruby_science)
    current_order = orders(:empty)
    cookies[:order_token] = current_order.token

    assert_no_created_order do
      2.times do
        post book_line_items_path(ruby_science), params: {
          line_item: {increment: 1}
        }
      end
    end

    assert_equal cookies[:order_token], current_order.token, "does not override the cookie"
    assert_line_item current_order, ruby_science, quantity: 2
  end

  test "#create with an Order token referencing a deleted Order" do
    ruby_science = books(:ruby_science)
    cookies[:order_token] = "abc123"

    assert_created_order do
      post book_line_items_path(ruby_science), params: {
        line_item: {increment: 1}
      }
    end
    current_order = Order.last

    assert_not_equal cookies[:order_token], "abc123", "overrides the stale token cookie"
    assert_equal cookies[:order_token], current_order.token, "sets the new token cookie"
    assert_line_item current_order, ruby_science
  end

  def assert_created_order(&block)
    count = Order.count

    assert_changes "Order.count", "creates a new Order record", from: count, to: count + 1 do
      block.call
    end
  end

  def assert_no_created_order(&block)
    assert_no_changes "Order.count", "does not create a new Order record" do
      block.call
    end
  end

  def assert_line_item(order, book, quantity: 1)
    line_item = LineItem.find_by!(order: order, book: book)
    title = line_item.title

    assert_includes order.books.pluck(:title), title, "LineItem records created for #{title}"
    assert_equal quantity, line_item.quantity
  end
end

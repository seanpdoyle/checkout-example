require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  test "#create without an existing Order creates a new Order" do
    ruby_science = books(:ruby_science)

    assert_created_order do
      post book_line_items_path(ruby_science), params: {
        line_item: {increment: "1"}
      }
    end
    current_order = Order.last

    assert_equal cookies[:order_id], current_order.signed_id, "stores Order#signed_id in cookie"
    assert_line_item current_order, ruby_science
  end

  test "#create with an existing LineItem in the current Order increments the quantity" do
    ruby_science = books(:ruby_science)
    current_order = Order.create!(
      line_items: [ruby_science.line_items.new(quantity: 1)]
    )
    cookies[:order_id] = current_order.signed_id

    assert_no_created_order do
      2.times do
        post book_line_items_path(ruby_science), params: {
          line_item: {increment: "1"}
        }
      end
    end

    assert_equal cookies[:order_id], current_order.signed_id, "does not override the cookie"
    assert_line_item current_order, ruby_science, quantity: 3
  end

  test "#create with an invalid signed_id in the cookies" do
    ruby_science = books(:ruby_science)
    cookies[:order_id] = "abc123"

    assert_created_order do
      post book_line_items_path(ruby_science), params: {
        line_item: {increment: "1"}
      }
    end
    current_order = Order.last

    assert_not_equal cookies[:order_id], "abc123", "overrides the stale cookie"
    assert_equal cookies[:order_id], current_order.signed_id, "sets the new cookie"
    assert_line_item current_order, ruby_science
  end

  test "#update with a positive increment value increments the LineItem's quantity" do
    ruby_science = books(:ruby_science)
    line_item = ruby_science.line_items.new(quantity: 1)
    current_order = Order.create!(line_items: [line_item])
    cookies[:order_id] = current_order.signed_id

    patch line_item_path(line_item), params: {
      line_item: {increment: "1"}
    }

    assert_response :redirect
    assert_line_item current_order, ruby_science, quantity: 2
  end

  test "#update with a negative increment value decrements the LineItem's quantity" do
    ruby_science = books(:ruby_science)
    line_item = ruby_science.line_items.new(quantity: 2)
    current_order = Order.create!(line_items: [line_item])
    cookies[:order_id] = current_order.signed_id

    patch line_item_path(line_item), params: {
      line_item: {increment: "-1"}
    }

    assert_response :redirect
    assert_line_item current_order, ruby_science, quantity: 1
  end

  test "#update with a negative increment for a single quantity LineItem destroys it" do
    ruby_science = books(:ruby_science)
    line_item = ruby_science.line_items.new(quantity: 1)
    current_order = Order.create!(line_items: [line_item])
    cookies[:order_id] = current_order.signed_id

    patch line_item_path(line_item), params: {
      line_item: {increment: "-1"}
    }

    assert_response :redirect
    assert_empty current_order.reload.line_items
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
    line_item = order.line_items.find_by!(book: book)

    assert_includes order.books.pluck(:title), book.title
    assert_equal quantity, line_item.quantity
  end
end

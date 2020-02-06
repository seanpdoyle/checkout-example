require "application_system_test_case"

class VisitorFinalizesTheirOrderTest < ApplicationSystemTestCase
  test "visitor finalizes order" do
    address = "1384 Broadway, New York, NY 10013"
    book = books(:ruby_science)
    order = Order.create!(books: [book])

    visit root_path(as: order)
    expand_cart
    click_on translate("orders.order.checkout")
    fill_in translate("helpers.label.checkout_shipment.shipping_address"), with: address
    click_on translate("helpers.submit.checkout_shipment.update")

    assert_text address
  end
end

require "application_system_test_case"

class VisitorFinalizesTheirOrderTest < ApplicationSystemTestCase
  test "visitor finalizes order" do
    shipping_address = "1384 Broadway, New York, NY 10013"
    billing_address = "41 Winter St 7th Floor, Boston, MA 02108"
    book = books(:ruby_science)
    order = Order.create!(books: [book])

    visit root_path(as: order)
    expand_cart
    click_on translate("orders.order.checkout")
    fill_in translate("helpers.label.checkout_shipment.shipping_address"), with: shipping_address
    click_on translate("helpers.submit.checkout_shipment.update")
    fill_in translate("helpers.label.checkout_payment.billing_address"), with: billing_address
    click_on translate("helpers.submit.checkout_payment.update")

    assert_text shipping_address
    assert_text billing_address
    assert_text number_to_currency(book.price)
  end
end

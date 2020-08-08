require "test_helper"

class Checkouts::ShipmentsControllerTest < ActionDispatch::IntegrationTest
  test "#update for an existing Order writes the Checkout attributes" do
    order = orders(:rails)
    shipment = shipments(:shipment_rails)

    patch shipment_path(order), params: {
      shipment: shipment.attributes
    }
    order.reload

    assert_redirected_to new_order_payment_path(order)
    assert_equal shipment.name, order.name
    assert_equal shipment.email, order.email
    assert_equal shipment.line1, order.line1
    assert_equal shipment.line2, order.line2
    assert_equal shipment.city, order.city
    assert_equal shipment.state, order.state
    assert_equal shipment.postal_code, order.postal_code
    assert_equal shipment.country, order.country
  end
end

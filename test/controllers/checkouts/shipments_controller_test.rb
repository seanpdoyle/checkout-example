require "test_helper"
require "minitest/autorun"

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

  test "#update associates the Order with a Stripe::PaymentIntent" do
    payment_intent = OpenStruct.new(id: "pi_123")
    order = orders(:rails)
    shipment = shipments(:shipment_rails)

    Stripe::PaymentIntent.stub(:create, payment_intent) do
      patch shipment_path(order), params: {
        shipment: shipment.attributes
      }
    end

    assert_equal order.reload.stripe_payment_intent_id, payment_intent.id
  end

  test "#update does not make a call to Stripe if a related Stripe::PaymentIntent already exists" do
    original_payment_intent = OpenStruct.new(id: "pi_123")
    new_payment_intent = OpenStruct.new(id: "pi_456")
    order = orders(:rails)
    order.update!(stripe_payment_intent_id: original_payment_intent.id)
    shipment = shipments(:shipment_rails)

    Stripe::PaymentIntent.stub(:create, new_payment_intent) do
      patch shipment_path(order), params: {
        shipment: shipment.attributes
      }
    end

    assert_equal order.reload.stripe_payment_intent_id, original_payment_intent.id
  end
end
require "test_helper"

class Checkouts::PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "#update marks the Order as paid" do
    freeze_time do
      order = shipments(:shipment_rails)

      patch payment_path(order)

      assert_equal Time.now, order.reload.paid_at
    end
  end

  test "#update redirects to Confirm the order and continue shopping" do
    order = shipments(:shipment_rails)

    patch payment_path(order)

    assert_redirected_to confirmation_url(order.becomes(Order).signed_id)
    assert_predicate cookies[:order_id], :blank?
  end
end

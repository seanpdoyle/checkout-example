require "test_helper"
require "test_helpers/stripe_test_helpers"

class Checkouts::PaymentsControllerTest < ActionDispatch::IntegrationTest
  include StripeTestHelpers

  test "#new raises ActiveRecord::RecordNotFound when the Order is not in the session" do
    current_order, other_order = orders(:rails, :tools)
    cookies[:order_id] = current_order.signed_id

    assert_raises ActiveRecord::RecordNotFound do
      get new_order_payment_path(other_order)
    end
  end

  test "#update marks the Order as paid" do
    freeze_time do
      order = prepare_for_payment! shipments(:shipment_rails)

      stub_payment_method("pm_visa") do |payment_method|
        patch payment_path(order), params: {
          payment: {
            stripe_payment_method: payment_method
          }
        }
      end

      assert_equal Time.now, order.reload.paid_at
    end
  end

  test "#update redirects to Confirm the order and continue shopping" do
    order = prepare_for_payment! shipments(:shipment_rails)

    stub_payment_method("pm_visa") do |payment_method|
      patch payment_path(order), params: {
        payment: {
          stripe_payment_method: payment_method
        }
      }
    end

    assert_redirected_to confirmation_url(order.becomes(Order).signed_id)
    assert_predicate cookies[:order_id], :blank?
  end

  test "#update rejects a submission where the payment method does not match Stripe's value" do
    order = prepare_for_payment! shipments(:shipment_rails)

    stub_payment_method("pm_visa") do |payment_method|
      assert_raises ActiveRecord::RecordInvalid do
        patch payment_path(order), params: {
          payment: {
            stripe_payment_method: "junk"
          }
        }
      end
    end
  end
end

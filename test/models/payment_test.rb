require "test_helper"
require "test_helpers/active_model_helpers"
require "test_helpers/stripe_test_helpers"

class PaymentTest < ActiveSupport::TestCase
  include ActiveModelHelpers
  include StripeTestHelpers

  test "validates Shipment attributes" do
    assert_validation_errors :email, Payment.new
  end

  test "invalid when the Order has not been prepared for payment" do
    assert_validation_errors :stripe_payment_intent_id, Payment.new
  end

  test "validates the provided stripe_payment_method matches Stripe's value" do
    payment = Payment.new(stripe_payment_method: "pm_123")

    stub_payment_method(payment.stripe_payment_method) do
      assert_no_validation_errors :stripe_payment_method, payment
    end
  end

  test "invalid without stripe_payment_method matching Stripe's value" do
    payment = Payment.new(
      stripe_payment_intent_id: "pi_visa",
      stripe_payment_method: "junk"
    )

    stub_payment_method("pm_visa") do
      assert_validation_errors :stripe_payment_method, payment
    end
  end

  test "#paid! marks paid_at to now" do
    freeze_time do
      payment = prepare_for_payment! shipments(:shipment_rails)

      stub_payment_method "pm_123" do |payment_method|
        payment.stripe_payment_method = payment_method

        payment.paid!
      end

      assert_equal Time.current, payment.reload.paid_at
    end
  end

  test "#paid! sets the paid_in_cents column to the final total" do
    payment = prepare_for_payment! shipments(:shipment_rails)

    payment.paid!

    assert_equal payment.line_items.sum(&:price_in_cents), payment.paid_in_cents
  end

  test "#paid! marks all related LineItem records as paid" do
    payment = prepare_for_payment! shipments(:shipment_rails)
    line_items = payment.line_items

    payment.paid!

    assert line_items.all?(&:paid?)
  end

  test "#paid! returns an Order instance" do
    payment = prepare_for_payment! shipments(:shipment_rails)

    confirmation = payment.paid!

    assert_equal Order, confirmation.class
  end
end

require "test_helper"
require "test_helpers/active_model_helpers"
require "test_helpers/stripe_test_helpers"

class OrderTest < ActiveSupport::TestCase
  include ActiveModelHelpers

  test "invalid without any LineItem records" do
    assert_validation_errors :line_items, Order.new
  end
end

class OrderShipmentTest < ActiveSupport::TestCase
  include ActiveModelHelpers

  test "invalid when name is missing" do
    assert_validation_errors :name, Order.new, context: :shipment
  end

  test "invalid when email is missing" do
    assert_validation_errors :email, Order.new, context: :shipment
  end

  test "invalid when line1 is missing" do
    assert_validation_errors :line1, Order.new, context: :shipment
  end

  test "invalid when city is missing" do
    assert_validation_errors :city, Order.new, context: :shipment
  end

  test "invalid when state is missing" do
    assert_validation_errors :state, Order.new, context: :shipment
  end

  test "invalid when postal_code is missing" do
    assert_validation_errors :postal_code, Order.new, context: :shipment
  end

  test "invalid when postal_code is less than 5 characters long" do
    assert_validation_errors :postal_code, Order.new(postal_code: "0000"), context: :shipment
  end

  test "does not require line2" do
    assert_no_validation_errors :line2, Order.new, context: :shipment
  end

  test "does not require country" do
    assert_no_validation_errors :country, Order.new, context: :shipment
  end

  test "defaults country to US" do
    shipment = Order.new

    country = shipment.country

    assert_equal "US", country
  end
end

class PaymentOrderTest < ActiveSupport::TestCase
  include ActiveModelHelpers
  include StripeTestHelpers

  test "validates shipment attributes" do
    assert_validation_errors :email, Order.new, context: :payment
  end

  test "invalid when the Order has not been prepared for payment" do
    assert_validation_errors :stripe_payment_intent_id, Order.new, context: :payment
  end

  test "validates the provided stripe_payment_method matches Stripe's value" do
    payment = Order.new(stripe_payment_method: "pm_123")

    stub_payment_method(payment.stripe_payment_method) do
      assert_no_validation_errors :stripe_payment_method, payment, context: :payment
    end
  end

  test "invalid without stripe_payment_method matching Stripe's value" do
    payment = Order.new(
      stripe_payment_intent_id: "pi_visa",
      stripe_payment_method: "junk"
    )

    stub_payment_method("pm_visa") do
      assert_validation_errors :stripe_payment_method, payment, context: :payment
    end
  end

  test "#paid! marks paid_at to now" do
    freeze_time do
      payment = prepare_for_payment! orders(:shipment_rails)

      stub_payment_method "pm_123" do |payment_method|
        payment.stripe_payment_method = payment_method

        payment.paid!
      end

      assert_equal Time.current, payment.reload.paid_at
    end
  end

  test "#paid! sets the paid_in_cents column to the final total" do
    payment = prepare_for_payment! orders(:shipment_rails)

    payment.paid!

    assert_equal payment.line_items.sum(&:price_in_cents), payment.paid_in_cents
  end

  test "#paid! marks all related LineItem records as paid" do
    payment = prepare_for_payment! orders(:shipment_rails)
    line_items = payment.line_items

    payment.paid!

    assert line_items.all?(&:paid?)
  end
end

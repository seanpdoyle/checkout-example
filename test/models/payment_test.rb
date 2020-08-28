require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "#paid! marks paid_at to now" do
    freeze_time do
      payment = prepare_for_payment! shipments(:shipment_rails)

      payment.paid!

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

  def prepare_for_payment!(shipment)
    shipment.prepare_for_payment!

    shipment.becomes(Payment)
  end
end

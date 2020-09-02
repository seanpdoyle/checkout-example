require "minitest/autorun"

module StripeTestHelpers
  def stub_payment_method(value)
    payment_intent = OpenStruct.new(payment_method: value)

    Stripe::PaymentIntent.stub(:retrieve, payment_intent) do
      yield(value)
    end
  end

  def prepare_for_payment!(shipment)
    shipment.prepare_for_payment!

    shipment
  end
end

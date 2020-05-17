require "test_helper"

module Checkout
  class ShipmentsControllerTest < ActionDispatch::IntegrationTest
    test "#update responds with a 422 when the Shipment is invalid" do
      checkout = Order.create!

      patch checkout_shipment_path(checkout), params: {
        checkout_shipment: {
          shipping_address: { line1: "" },
        },
      }

      assert_response :unprocessable_entity
      assert_validation_error_text Address, :line1
    end

    def assert_validation_error_text(model_class, attribute)
      record = model_class.new(attribute => "")

      record.validate

      record.errors[attribute].each do |message|
        assert_includes css_select("body").text, message
      end
    end
  end
end

require "test_helper"

module Checkout
  class ShipmentTest < ActiveSupport::TestCase
    test "#shipping_address is accessibile when cast to another Order subclass" do
      billing = Checkout::Billing.new

      shipping_address = billing.shipping_address

      assert_kind_of Address, shipping_address
    end

    test "#shipping_address with a default value is cast to an Address" do
      shipment = Checkout::Shipment.new

      shipping_address = shipment.shipping_address

      assert_nil shipping_address.line1
      assert_nil shipping_address.line2
    end

    test "#shipping_address with a an empty hash is cast to an Address" do
      shipment = Checkout::Shipment.new(shipping_address: {})

      shipping_address = shipment.shipping_address

      assert_nil shipping_address.line1
      assert_nil shipping_address.line2
    end

    test "#shipping_address is cast to an Address" do
      shipment = Checkout::Shipment.new(shipping_address: {
        line1: "1384 Broadway",
        line2: "Floor 20",
      })

      shipping_address = shipment.shipping_address

      assert_equal "1384 Broadway", shipping_address.line1
      assert_equal "Floor 20", shipping_address.line2
    end
  end

  class ShipmentValidationsTest < ActiveSupport::TestCase
    test "is invalid when the email is blank" do
      shipment = Checkout::Shipment.new(email: nil)

      valid = shipment.validate

      assert_equal false, valid
      assert_includes shipment.errors, :email
    end

    test "is invalid when the shipping_address is blank" do
      shipment = Checkout::Shipment.new(shipping_address: nil)

      valid = shipment.validate

      assert_equal false, valid
      assert_includes shipment.errors, :shipping_address
    end

    test "is invalid that the shipping_address is invalid" do
      shipment = Checkout::Shipment.new(shipping_address: { line2: "Floor 20" })

      valid = shipment.validate

      assert_equal false, valid
      assert_includes shipment.errors, :shipping_address
      assert_includes shipment.shipping_address.errors, :line1
    end

    test "is valid when the shipping_address is valid" do
      shipment = Checkout::Shipment.new(shipping_address: {
        line1: "1384 Broadway",
        city: "New York",
        state: "NY",
        postal_code: "10013",
        country: "US",
      })

      shipment.validate

      assert_not_includes shipment.errors, :shipping_address
    end
  end
end

require "test_helper"

module Checkout
  class BillingTest < ActiveSupport::TestCase
    test "#billing_address is accessibile when cast to another Order subclass" do
      shipment = Checkout::Shipment.new

      billing_address = shipment.billing_address

      assert_kind_of Address, billing_address
    end

    test "#billing_address with a default value is cast to an Address" do
      billing = Checkout::Billing.new

      billing_address = billing.billing_address

      assert_nil billing_address.line1
      assert_nil billing_address.line2
    end

    test "#billing_address with a an empty hash is cast to an Address" do
      billing = Checkout::Billing.new(billing_address: {})

      billing_address = billing.billing_address

      assert_nil billing_address.line1
      assert_nil billing_address.line2
    end

    test "#billing_address is cast to an Address" do
      billing = Checkout::Billing.new(billing_address: {
        line1: "1384 Broadway",
        line2: "Floor 20",
      })

      billing_address = billing.billing_address

      assert_equal "1384 Broadway", billing_address.line1
      assert_equal "Floor 20", billing_address.line2
    end
  end

  class BillingValidationsTest < ActiveSupport::TestCase
    test "is invalid when the billing_address is blank" do
      billing = Checkout::Billing.new(billing_address: nil)

      valid = billing.validate

      assert_equal false, valid
      assert_not_empty billing.errors[:billing_address]
    end

    test "is invalid that the billing_address is invalid" do
      billing = Checkout::Billing.new(billing_address: { line2: "Floor 20" })

      valid = billing.validate

      assert_equal false, valid
      assert_not_empty billing.errors[:billing_address]
      assert_not_empty billing.billing_address.errors[:line1]
    end

    test "is valid when the billing_address is valid" do
      billing = Checkout::Billing.new(billing_address: {
        line1: "1384 Broadway",
        city: "New York",
        state: "NY",
        postal_code: "10013",
        country: "US",
      })

      billing.validate

      assert_empty billing.errors[:billing_address]
    end
  end
end

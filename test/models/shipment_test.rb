require "test_helper"

class ShipmentTest < ActiveSupport::TestCase
  test "invalid without any LineItem records" do
    assert_validation_errors :line_items, Shipment.new
  end

  test "invalid when name is missing" do
    assert_validation_errors :name, Shipment.new
  end

  test "invalid when email is missing" do
    assert_validation_errors :email, Shipment.new
  end

  test "invalid when line1 is missing" do
    assert_validation_errors :line1, Shipment.new
  end

  test "invalid when city is missing" do
    assert_validation_errors :city, Shipment.new
  end

  test "invalid when state is missing" do
    assert_validation_errors :state, Shipment.new
  end

  test "invalid when postal_code is missing" do
    assert_validation_errors :postal_code, Shipment.new
  end

  test "invalid when postal_code is less than 5 characters long" do
    assert_validation_errors :postal_code, Shipment.new(postal_code: "0000")
  end

  test "does not require line2" do
    assert_no_validation_errors :line2, Shipment.new
  end

  test "does not require country" do
    assert_no_validation_errors :country, Shipment.new
  end

  test "defaults country to US" do
    shipment = Shipment.new

    country = shipment.country

    assert_equal "US", country
  end

  def assert_validation_errors(attribute, record)
    assert_not record.validate
    assert_includes record.errors, attribute
  end

  def assert_no_validation_errors(attribute, record)
    record.validate

    assert_not_includes record.errors, attribute
  end
end

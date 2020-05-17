require "application_system_test_case"

class VisitorFinalizesTheirOrderTest < ApplicationSystemTestCase
  test "visitor finalizes order" do
    shipping_address = Address.new(
      line1: "1384 Broadway",
      line2: "Floor 20",
      city: "New York",
      state: "NY",
      postal_code: "10013",
      country: "US",
    )
    billing_address = shipping_address.dup
    book = books(:ruby_science)
    order = Order.create!(books: [book])

    visit root_path(as: order)
    expand_cart
    click_on translate("orders.order.checkout")
    fill_in_address shipping_address
    click_on submit(:checkout_shipment, :update)
    fill_in_address billing_address
    click_on submit(:checkout_billing, :update)

    assert_text shipping_address.line1
    assert_text billing_address.line1
    assert_text number_to_currency(book.price)
  end

  def fill_in_address(address)
    address.attributes.each do |attribute, value|
      fill_in label(:address, attribute), with: value
    end
  end

  def submit(model_name, action = :create)
    translate(action, scope: "helpers.submit.#{model_name}")
  end

  def label(model_name, attribute)
    translate(attribute, scope: "helpers.label.#{model_name}")
  end
end

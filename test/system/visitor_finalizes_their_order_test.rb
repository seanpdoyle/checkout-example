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
    within :fieldset, text: "Contact Information" do
      fill_in label(:checkout_shipment, :email), with: "customer@example.com"
    end
    within :fieldset, text: "Shipping Address" do
      fill_in_address shipping_address
    end
    click_on submit(:checkout_shipment, :update)
    within :fieldset, text: "Billing Address" do
      fill_in_address billing_address
    end
    click_on submit(:checkout_billing, :update)
    within_frame find(".StripeElement iframe") do
      find(%([aria-label="Credit or debit card number"])).fill_in with: "4242424242424242"
      find(%([aria-label="Credit or debit card expiration date"])).fill_in with: "0130"
      find(%([aria-label="Credit or debit card CVC/CVV"])).fill_in with: "111"
      find(%([aria-label="ZIP"])).fill_in with: billing_address.postal_code
    end
    click_on submit(:checkout_payment, :update)

    assert_text "Success!"
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

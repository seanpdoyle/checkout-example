require "application_system_test_case"

class VisitorFinalizesTheirOrderTest < ApplicationSystemTestCase
  test "visitor finalizes order" do
    book = books(:ruby_science)
    order = Order.create!(books: [book])

    visit root_path(as: order)
    expand_cart
    click_on translate("orders.order.checkout")
    fill_in label(:address, :line1), with: "1384 Broadway"
    fill_in label(:address, :line2), with: "Floor 20"
    fill_in label(:address, :city), with: "New York"
    fill_in label(:address, :state), with: "NY"
    fill_in label(:address, :postal_code), with: "10013"
    fill_in label(:address, :country), with: "US"
    click_on submit(:checkout_shipment, :update)
    fill_in label(:address, :line1), with: "1384 Broadway"
    fill_in label(:address, :line2), with: "Floor 20"
    fill_in label(:address, :city), with: "New York"
    fill_in label(:address, :state), with: "NY"
    fill_in label(:address, :postal_code), with: "10013"
    fill_in label(:address, :country), with: "US"
    click_on submit(:checkout_billing, :update)

    assert_text shipping_address
    assert_text billing_address
    assert_text number_to_currency(book.price)
  end

  def submit(model_name, action = :create)
    translate(action, scope: "helpers.submit.#{model_name}")
  end

  def label(model_name, attribute)
    translate(attribute, scope: "helpers.label.#{model_name}")
  end
end

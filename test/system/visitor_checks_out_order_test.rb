require "application_system_test_case"

class VisitorChecksOutOrderTest < ApplicationSystemTestCase
  test "visitor checks out order" do
    ruby_science = books(:ruby_science)

    2.times { add_to_cart ruby_science }
    checkout

    assert_no_cart
    assert_text translate("checkouts.shipments.new.title")
    assert_total ruby_science.price_in_dollars * 2
  end

  test "visitor checks out with shipping details" do
    shipment = shipments(:shipment_rails)

    shipment.books.each { |book| add_to_cart book }
    checkout
    submit_shipment_form(shipment)

    assert_text translate("checkouts.payments.new.title")
    assert_text shipment.name
    assert_text shipment.email
    assert_address shipment
    assert_total shipment.total_in_dollars
  end

  test "visitor submits payment for an order" do
    shipment = shipments(:shipment_rails)

    shipment.books.each { |book| add_to_cart book }
    checkout
    submit_shipment_form(shipment)
    fill_in_stripe label(:payment, :card_number), with: 4242_4242_4242_4242
    fill_in_stripe label(:payment, :card_expiry), with: 3_30
    fill_in_stripe label(:payment, :card_cvc), with: 737
    click_on submit(:payment, :update)

    assert_text translate("checkouts.confirmations.show.title")
    assert_text translate("checkouts.confirmations.show.call_to_action")
    assert_text shipment.email
    assert_total shipment.total_in_dollars
  end

  def checkout
    expand_cart

    click_on translate("orders.order.checkout")
  end

  def submit_shipment_form(shipment)
    fill_in label(:shipment, :name), with: shipment.name
    fill_in label(:shipment, :email), with: shipment.email
    fill_in label(:shipment, :line1), with: shipment.line1
    fill_in label(:shipment, :line2), with: shipment.line2
    fill_in label(:shipment, :city), with: shipment.city
    fill_in label(:shipment, :state), with: shipment.state
    fill_in label(:shipment, :postal_code), with: shipment.postal_code
    click_on submit(:shipment, :update)
  end

  def fill_in_stripe(locator, *arguments)
    label = find("label", text: locator)
    input = find_by_id(label["for"])

    within_frame(input.find("iframe")) { fill_in(*arguments) }
  end

  def assert_address(address)
    assert_text address.line1
    assert_text address.line2
    assert_text address.city
    assert_text address.state
    assert_text address.postal_code
  end

  def assert_no_cart
    open_text = translate("application.navigation.order.open")

    assert_no_selector("details:not([open]) summary", text: open_text)
  end
end

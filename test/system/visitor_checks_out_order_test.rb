require "application_system_test_case"
require "test_helpers/stripe_test_helpers"

class VisitorChecksOutOrderTest < ApplicationSystemTestCase
  include StripeTestHelpers

  test "visitor checks out order" do
    ruby_science = books(:ruby_science)

    add_to_cart ruby_science, increment: 2
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

  test "visitor submits invalid shipping details" do
    ruby_science = books(:ruby_science)

    add_to_cart ruby_science
    checkout
    click_on submit(:shipment, :update)

    assert_text translate("errors.messages.blank")
    assert_field label(:shipment, :name)
    assert_field label(:shipment, :email)
    assert_field label(:shipment, :line1)
    assert_field label(:shipment, :line2)
    assert_field label(:shipment, :city)
    assert_field label(:shipment, :state)
    assert_field label(:shipment, :postal_code)
  end

  test "visitor submits payment for an order" do
    shipment = shipments(:shipment_rails)

    shipment.books.each { |book| add_to_cart book }
    checkout
    submit_shipment_form(shipment)
    submit_payment_form(
      card_number: 4242_4242_4242_4242,
      card_expiry: 3_30,
      card_cvc: 737
    )

    with_wait_time seconds: 3 do
      assert_text translate("checkouts.confirmations.show.title")
      assert_text translate("checkouts.confirmations.show.call_to_action")
      assert_text shipment.email
      assert_total shipment.total_in_dollars
    end
  end

  test "visitor is notified when a payment submission is declined" do
    shipment = shipments(:shipment_rails)

    shipment.books.each { |book| add_to_cart book }
    checkout
    submit_shipment_form(shipment)
    submit_payment_form(
      card_number: 4000_0000_0000_0002,
      card_expiry: 3_30,
      card_cvc: 737
    )

    assert_no_text translate("checkouts.confirmations.show.title")
    assert_describedby label(:payment, :card_number), "Your card was declined."
  end

  test "visitor is notified when a payment submission has an expired card" do
    shipment = shipments(:shipment_rails)

    shipment.books.each { |book| add_to_cart book }
    checkout
    submit_shipment_form(shipment)
    submit_payment_form(
      card_number: 4000_0000_0000_0069,
      card_expiry: 3_30,
      card_cvc: 737
    )

    assert_no_text translate("checkouts.confirmations.show.title")
    assert_describedby label(:payment, :card_expiry), "Your card has expired."
  end

  test "visitor is notified when a payment submission's card verification check fails" do
    shipment = shipments(:shipment_rails)

    shipment.books.each { |book| add_to_cart book }
    checkout
    submit_shipment_form(shipment)
    submit_payment_form(
      card_number: 4000_0000_0000_0101,
      card_expiry: 3_30,
      card_cvc: 737
    )

    assert_no_text translate("checkouts.confirmations.show.title")
    assert_describedby label(:payment, :card_cvc), "Your card's security code is incorrect."
  end

  def add_to_cart(book, increment: 1)
    visit book_path(book)
    fill_in label(:line_item, :increment), with: increment
    click_on submit(:line_item)
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

  def assert_describedby(locator, text)
    input = find_stripe_field(locator)
    described_by_element = find_by_id(input["aria-describedby"])

    within described_by_element do
      assert_text text
    end
  end

  def submit_payment_form(card_number:, card_expiry:, card_cvc:)
    fill_in_stripe label(:payment, :card_number), with: card_number
    fill_in_stripe label(:payment, :card_expiry), with: card_expiry
    fill_in_stripe label(:payment, :card_cvc), with: card_cvc
    click_on submit(:payment, :update)
  end

  def fill_in_stripe(locator, *arguments)
    input = find_stripe_field(locator)

    within_frame(input.find("iframe")) { fill_in(*arguments) }
  end

  def find_stripe_field(locator)
    label = find("label", text: locator)

    find_by_id(label["for"])
  end

  def label(i18n_key, attribute)
    translate(attribute, scope: [:helpers, :label, i18n_key])
  end

  def submit(i18n_key, action = :create)
    translate(action, scope: [:helpers, :submit, i18n_key])
  end

  def assert_address(address)
    assert_text address.line1
    assert_text address.line2
    assert_text address.city
    assert_text address.state
    assert_text address.postal_code
  end

  def assert_no_cart
    assert_no_selector("details", text: translate("layouts.application.order"), visible: :all)
  end
end

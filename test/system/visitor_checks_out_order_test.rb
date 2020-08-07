require "application_system_test_case"

class VisitorChecksOutOrderTest < ApplicationSystemTestCase
  test "visitor checks out order" do
    ruby_science = books(:ruby_science)

    add_to_cart ruby_science, increment: 2
    checkout

    assert_no_cart
    assert_text translate("checkouts.shipments.new.title")
    assert_total ruby_science.price_in_dollars * 2
  end

  test "visitor checks out with shipping details" do
    ruby_science = books(:ruby_science)
    shipment = Shipment.new(
      name: "Savvy Shopper",
      email: "shopper@example.com",
      line1: "1384 Broadway",
      line2: "Floor 20",
      city: "New York",
      state: "NY",
      postal_code: "10013"
    )

    add_to_cart ruby_science
    checkout
    fill_in label(:shipment, :name), with: shipment.name
    fill_in label(:shipment, :email), with: shipment.email
    fill_in label(:shipment, :line1), with: shipment.line1
    fill_in label(:shipment, :line2), with: shipment.line2
    fill_in label(:shipment, :city), with: shipment.city
    fill_in label(:shipment, :state), with: shipment.state
    fill_in label(:shipment, :postal_code), with: shipment.postal_code
    click_on submit(:shipment, :update)

    assert_text translate("checkouts.payments.new.title")
    assert_text shipment.name
    assert_text shipment.email
    assert_address shipment
    assert_total order.total_in_dollars
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

require "application_system_test_case"

class VisitorChecksOutOrderTest < ApplicationSystemTestCase
  test "visitor checks out order" do
    ruby_science = books(:ruby_science)

    visit book_path(ruby_science)
    2.times { click_on submit(:line_item) }
    expand_cart
    click_on translate("orders.order.checkout")

    assert_no_cart
    assert_text translate("checkouts.shipments.new.title")
    assert_total ruby_science.price_in_dollars * 2
  end

  def assert_no_cart
    open_text = translate("application.navigation.order.open")

    assert_no_selector("details:not([open]) summary", text: open_text)
  end
end

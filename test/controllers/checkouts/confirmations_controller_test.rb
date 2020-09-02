require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "#show fetches the Confirmation by its signed_id" do
    confirmation = orders(:payment_rails)

    get confirmation_path(confirmation.signed_id)

    assert_response :success
  end

  test "#show raises ActiveRecord::RecordNotFound error when visited with id" do
    confirmation = orders(:payment_rails)

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      get confirmation_path(confirmation.id)
    end
  end

  test "#show redirects to the payment form if not Checked out" do
    current_order = orders(:shipment_rails)
    cookies[:order_id] = current_order.signed_id

    get confirmation_path(current_order.signed_id)

    assert_redirected_to new_order_payment_url(current_order)
  end
end

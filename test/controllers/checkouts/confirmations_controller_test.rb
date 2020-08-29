require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "#show fetches the Confirmation by its signed_id" do
    confirmation = payments(:payment_rails).becomes(Order)

    get confirmation_path(confirmation.signed_id)

    assert_response :success
  end

  test "#show raises ActiveRecord::RecordNotFound error when visited with id" do
    confirmation = payments(:payment_rails).becomes(Order)

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      get confirmation_path(confirmation.id)
    end
  end

  test "#show redirects to the Payment form if not Checked out" do
    current_order = shipments(:shipment_rails).becomes(Order)
    cookies[:order_id] = current_order.signed_id

    get confirmation_path(current_order.signed_id)

    assert_redirected_to new_order_payment_url(current_order)
  end
end

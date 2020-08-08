require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "#show fetches the Confirmation by its signed_id" do
    order = orders(:rails)

    get confirmation_path(order.signed_id)

    assert_response :success
  end

  test "#show raises ActiveRecord::RecordNotFound error when visited with id" do
    order = orders(:rails)

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      get confirmation_path(order.id)
    end
  end
end

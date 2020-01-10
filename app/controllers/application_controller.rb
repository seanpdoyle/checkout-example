class ApplicationController < ActionController::Base
  before_action do
    if (signed_order_id = cookies[:order_id])
      Current.order = Order.find_signed(signed_order_id)
    end

    Current.order ||= Order.new
  end
end

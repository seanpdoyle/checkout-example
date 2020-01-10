class ApplicationController < ActionController::Base
  before_action do
    if (order_token = cookies[:order_token])
      Current.order = Order.find_by(token: order_token)
    end

    Current.order ||= Order.new
  end
end

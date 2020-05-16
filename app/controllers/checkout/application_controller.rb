module Checkout
  class ApplicationController < ::ApplicationController
    before_action do
      order = Order.find(params.fetch(:checkout_id) { params.fetch(:id) })

      if order.finalized?
        redirect_to order_url(order)
      end
    end
  end
end

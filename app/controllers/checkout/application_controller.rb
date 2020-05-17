module Checkout
  class ApplicationController < ::ApplicationController
    before_action :redirect_if_charged!

    private

    def redirect_if_charged!
      order = Order.find(params.fetch(:checkout_id) { params.fetch(:id) })

      if order.charged?
        redirect_to checkout_confirmation_url(order)
      end
    end
  end
end

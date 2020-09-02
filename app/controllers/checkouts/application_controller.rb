module Checkouts
  class ApplicationController < ::ApplicationController
    def find_order(order_id = params[:order_id])
      Order.where(id: Current.order).find(order_id)
    end
  end
end

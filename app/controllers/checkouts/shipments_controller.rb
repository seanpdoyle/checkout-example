module Checkouts
  class ShipmentsController < ApplicationController
    def new
      shipment = Shipment.find(params[:order_id])

      render locals: {shipment: shipment}
    end

    def update
      redirect_to new_order_payment_url(params[:id]), turbolinks: :advance
    end
  end
end

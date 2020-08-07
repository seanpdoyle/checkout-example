module Checkouts
  class ShipmentsController < ApplicationController
    def new
      shipment = Shipment.find(params[:order_id])

      render locals: {shipment: shipment}
    end
  end
end

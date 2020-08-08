module Checkouts
  class ShipmentsController < ApplicationController
    def new
      shipment = Shipment.find(params[:order_id])

      render locals: {shipment: shipment}
    end

    def update
      shipment = Shipment.find(params[:id])

      shipment.update!(shipment_params)

      redirect_to new_order_payment_url(shipment), turbolinks: :advance
    end

    private

    def shipment_params
      params.require(:shipment).permit(
        :name,
        :email,
        :line1,
        :line2,
        :city,
        :state,
        :postal_code,
        :country
      )
    end
  end
end

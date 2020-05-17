module Checkout
  class ShipmentsController < ApplicationController
    def new
      checkout = Checkout::Shipment.find(params[:checkout_id])

      render locals: {
        checkout: checkout,
      }
    end

    def update
      checkout = Checkout::Shipment.find(params[:id])

      checkout.update!(checkout_shipment_params)

      redirect_to new_checkout_billing_url(checkout)
    end

    private

    def checkout_shipment_params
      params.require(:checkout_shipment).permit(
        shipping_address: [
          :line1,
          :line2,
          :city,
          :state,
          :country,
          :postal_code,
        ]
      )
    end
  end
end

module Checkouts
  class ShipmentsController < ApplicationController
    def new
      shipment = Shipment.find(params[:order_id])

      render locals: {shipment: shipment}
    end

    def update
      shipment = Shipment.find(params[:id])
      shipment.assign_attributes(shipment_params)

      shipment.transaction do
        shipment.save!

        if shipment.stripe_payment_intent_id.nil?
          shipment.prepare_for_payment!
        end
      end

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

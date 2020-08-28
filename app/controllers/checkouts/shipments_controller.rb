module Checkouts
  class ShipmentsController < ApplicationController
    def new
      shipment = find_order.becomes(Shipment)

      render locals: {shipment: shipment}
    end

    def update
      shipment = Shipment.find(params[:id])

      shipment.assign_attributes(shipment_params)

      if shipment.valid?
        shipment.transaction do
          shipment.save!

          if shipment.stripe_payment_intent_id.nil?
            shipment.prepare_for_payment!
          end
        end

        redirect_to new_order_payment_url(shipment), turbolinks: :advance
      else
        render :new, status: :unprocessable_entity, locals: {
          shipment: shipment
        }
      end
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

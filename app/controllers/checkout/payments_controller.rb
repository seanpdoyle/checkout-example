module Checkout
  class PaymentsController < ApplicationController
    def new
      checkout = Checkout::Payment.find(params[:checkout_id])
      checkout.prepare_for_payment!

      render locals: { checkout: checkout }
    end

    def update
      checkout = Checkout::Payment.find(params[:id])

      checkout.assign_attributes(checkout_payment_params)

      checkout.save!(:finalization)

      redirect_to order_url(checkout)
    end

    private

    def checkout_payment_params
      params.require(:checkout_payment).permit(
        :billing_address,
        :bill_with_shipping_address,
      )
    end
  end
end

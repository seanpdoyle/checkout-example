module Checkout
  class PaymentsController < ApplicationController
    def new
      checkout = Checkout::Payment.find(params[:checkout_id])

      render locals: { checkout: checkout }
    end

    def update
      checkout = Checkout::Payment.find(params[:id])

      checkout.update!(checkout_payment_params)

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

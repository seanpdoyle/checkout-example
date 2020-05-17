module Checkout
  class BillingsController < ApplicationController
    def new
      checkout = Checkout::Billing.find(params[:checkout_id])

      render locals: {
        checkout: checkout,
      }
    end

    def update
      checkout = Checkout::Billing.find(params[:id])

      checkout.update!(checkout_billing_params)

      redirect_to new_checkout_payment_url(checkout)
    end

    private

    def checkout_billing_params
      params.require(:checkout_billing).permit(
        billing_address: [
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

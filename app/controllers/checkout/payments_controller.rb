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

      checkout.save!(context: :charge)

      cookies.delete(:order_token)

      redirect_to order_url(checkout)
    end

    private

    def checkout_payment_params
      params.require(:checkout_payment).permit(
        :stripe_payment_method_id,
      )
    end
  end
end

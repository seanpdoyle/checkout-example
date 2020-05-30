module Checkout
  class PaymentsController < ApplicationController
    def new
      checkout = Checkout::Payment.find(params[:checkout_id])
      checkout.prepare_for_payment!

      render locals: { checkout: checkout }
    end

    def update
      checkout = Checkout::Payment.find(params[:id])

      checkout.charge!
      OrdersMailer.confirmation(checkout.becomes(Order)).deliver_later
      cookies.delete(:order_token)

      redirect_to checkout_confirmation_url(checkout)
    end
  end
end

module Checkouts
  class PaymentsController < ApplicationController
    def new
      payment = Payment.find(params[:order_id])

      render locals: {payment: payment}
    end

    def update
      payment = Payment.find(params[:id])

      confirmation = payment.paid!
      cookies.delete(:order_id)

      redirect_to confirmation_url(confirmation.signed_id), turbolinks: :advance
    end
  end
end

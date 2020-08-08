module Checkouts
  class PaymentsController < ApplicationController
    def new
      payment = Payment.find(params[:order_id])

      render locals: {payment: payment}
    end

    def update
      payment = Payment.find(params[:id])

      redirect_to confirmation_url(payment.signed_id), turbolinks: :advance
    end
  end
end

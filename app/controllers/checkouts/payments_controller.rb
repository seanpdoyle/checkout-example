module Checkouts
  class PaymentsController < ApplicationController
    def new
      payment = Payment.find(params[:order_id])

      render locals: {payment: payment}
    end
  end
end

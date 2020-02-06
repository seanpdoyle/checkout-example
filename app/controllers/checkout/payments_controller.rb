module Checkout
  class PaymentsController < ApplicationController
    def new
      checkout = Checkout::Payment.find(params[:checkout_id])

      render locals: { checkout: checkout }
    end
  end
end

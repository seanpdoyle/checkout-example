module Checkouts
  class PaymentsController < ApplicationController
    def new
      order = find_order

      if order.valid?(:shipment)
        render locals: {payment: order}
      else
        redirect_to new_order_shipment_url(order)
      end
    end

    def update
      payment = Order.find(params[:id])
      payment.assign_attributes(payment_params)

      payment.paid!
      cookies.delete(:order_id)

      redirect_to confirmation_url(payment.signed_id), turbolinks: :advance
    end

    private

    def payment_params
      params.require(:payment).permit(:stripe_payment_method)
    end
  end
end

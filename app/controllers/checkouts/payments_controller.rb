module Checkouts
  class PaymentsController < ApplicationController
    def new
      order = find_order

      if order.becomes(Shipment).valid?
        render locals: {payment: order.becomes(Payment)}
      else
        redirect_to new_order_shipment_url(order)
      end
    end

    def update
      payment = Payment.find(params[:id])
      payment.assign_attributes(payment_params)

      confirmation = payment.paid!
      cookies.delete(:order_id)

      redirect_to confirmation_url(confirmation.signed_id), turbolinks: :advance
    end

    private

    def payment_params
      params.require(:payment).permit(:stripe_payment_method)
    end
  end
end

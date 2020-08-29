module Checkouts
  class ConfirmationsController < ApplicationController
    def show
      confirmation = Order.find_signed!(params[:id])

      if confirmation.paid?
        render locals: {confirmation: confirmation}
      else
        redirect_to new_order_payment_path(confirmation)
      end
    end
  end
end

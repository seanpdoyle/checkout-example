module Checkout
  class ConfirmationsController < ApplicationController
    skip_before_action :redirect_if_charged!, only: :show

    def show
      checkout = Order.find(params[:id])

      render locals: { checkout: checkout }
    end
  end
end

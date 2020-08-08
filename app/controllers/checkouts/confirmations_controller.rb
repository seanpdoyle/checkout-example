module Checkouts
  class ConfirmationsController < ApplicationController
    def show
      confirmation = Order.find_signed!(params[:id])

      render locals: {confirmation: confirmation}
    end
  end
end

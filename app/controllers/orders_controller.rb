class OrdersController < ApplicationController
  def show
    order = Order.find(params[:id])

    render locals: { order: order }
  end
end

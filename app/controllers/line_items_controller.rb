class LineItemsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    line_item = LineItem.create_or_find_by!(
      order: Current.order,
      book: book
    )

    line_item.update!(line_item_params)

    cookies[:order_token] = Current.order.token

    redirect_back(
      fallback_location: root_url,
      flash: {notice: translate(".notice", title: line_item.title)}
    )
  end

  private

  def line_item_params
    params.require(:line_item).permit(:increment)
  end
end

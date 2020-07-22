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

  def destroy
    line_item = Current.order.line_items.find(params[:id])

    line_item.destroy!

    redirect_back(
      fallback_location: root_url,
      flash: {notice: translate(".notice", title: line_item.title)}
    )
  end

  def update
    line_item = Current.order.line_items.find(params[:id])

    LineItem.transaction do
      line_item.update!(line_item_params)

      if line_item.quantity.zero?
        line_item.destroy!
      end
    end

    redirect_back(fallback_location: root_url)
  end

  private

  def line_item_params
    params.require(:line_item).permit(:increment)
  end
end

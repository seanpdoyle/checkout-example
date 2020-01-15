class LineItemsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    order = Current.order

    if order.new_record?
      order.update!(
        line_items: [book.line_items.new(line_item_params)]
      )
    else
      line_item = order.line_items.create_or_find_by!(book: book)
      line_item.update!(line_item_params)
    end

    cookies[:order_id] = order.signed_id

    redirect_back(
      fallback_location: root_url,
      flash: {notice: translate(".notice", title: book.title)}
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

  private

  def line_item_params
    params.require(:line_item).permit(:increment)
  end
end

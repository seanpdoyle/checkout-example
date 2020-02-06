class AddShippingAddressToOrders < ActiveRecord::Migration[6.0]
  def change
    change_table :orders do |t|
      t.text :shipping_address
    end
  end
end

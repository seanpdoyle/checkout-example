class AddShippingAddressToOrders < ActiveRecord::Migration[6.0]
  def change
    change_table :orders do |t|
      t.json :shipping_address, null: false, default: {}
    end
  end
end

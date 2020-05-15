class AddBillingAddressToOrders < ActiveRecord::Migration[6.0]
  def change
    change_table :orders do |t|
      t.text :billing_address
      t.boolean :bill_with_shipping_address, null: false, default: false
    end
  end
end

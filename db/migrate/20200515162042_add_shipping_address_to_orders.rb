class AddShippingAddressToOrders < ActiveRecord::Migration[6.0]
  def change
    enable_extension :citext

    change_table :orders do |t|
      t.citext :email
      t.jsonb :shipping_address, null: false, default: Hash.new
    end
  end
end

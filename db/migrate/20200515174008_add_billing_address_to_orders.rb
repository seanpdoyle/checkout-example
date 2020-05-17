class AddBillingAddressToOrders < ActiveRecord::Migration[6.0]
  def change
    change_table :orders do |t|
      t.jsonb :billing_address, null: false, default: Hash.new
    end
  end
end

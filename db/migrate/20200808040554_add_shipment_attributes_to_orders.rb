class AddShipmentAttributesToOrders < ActiveRecord::Migration[6.1]
  def change
    enable_extension :citext

    change_table :orders do |t|
      t.citext :name
      t.citext :email
      t.citext :line1
      t.citext :line2
      t.citext :city
      t.citext :state
      t.citext :postal_code
      t.citext :country, null: false, default: "US"
    end
  end
end

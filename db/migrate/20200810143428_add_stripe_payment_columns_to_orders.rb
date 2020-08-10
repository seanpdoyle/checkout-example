class AddStripePaymentColumnsToOrders < ActiveRecord::Migration[6.1]
  def change
    change_table :orders do |t|
      t.string :currency, null: false, default: "usd"
      t.string :stripe_payment_intent_id
    end
  end
end

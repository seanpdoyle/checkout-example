class AddStripePaymentIntentIdToOrders < ActiveRecord::Migration[6.0]
  def change
    change_table :orders do |t|
      t.string :stripe_payment_intent_id
    end
  end
end

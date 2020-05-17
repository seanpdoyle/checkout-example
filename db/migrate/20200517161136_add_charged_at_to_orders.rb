class AddChargedAtToOrders < ActiveRecord::Migration[6.0]
  def change
    change_table :orders do |t|
      t.timestamp :charged_at
    end
  end
end

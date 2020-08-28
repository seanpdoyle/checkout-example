class AddPaidColumnsToLineItems < ActiveRecord::Migration[6.1]
  def change
    change_table :line_items do |t|
      t.datetime :paid_at

      t.integer :paid_in_cents, null: false, default: 0
    end
  end
end

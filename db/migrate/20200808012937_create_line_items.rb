class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.belongs_to :order, null: false, index: true
      t.belongs_to :book, null: false, index: true

      t.integer :quantity, null: false, default: 0

      t.index [:book_id, :order_id], unique: true

      t.timestamps
    end
  end
end

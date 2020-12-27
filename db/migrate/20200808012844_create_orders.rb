class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :token, null: false

      t.index :token, unique: true

      t.timestamps
    end
  end
end

class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :order_number
      t.decimal :subtotal, precision: 6, scale: 2
      t.decimal :tax, precision: 6, scale: 2
      t.decimal :total, precision: 6, scale: 2

      t.timestamps
    end
    add_index :orders, :user_id
  end
end

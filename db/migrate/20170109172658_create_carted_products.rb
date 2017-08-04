class CreateCartedProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :carted_products do |t|
      t.integer :product_id
      t.integer :user_id
      t.integer :order_id
      t.integer :quantity
      t.boolean :purchased, default: false

      t.timestamps
    end
    add_index :carted_products, :product_id
    add_index :carted_products, :user_id
    add_index :carted_products, :order_id
  end
end

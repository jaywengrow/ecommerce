class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.decimal :price, precision: 6, scale: 2
      t.text :description
      t.string :dimensions
      t.string :color
      t.string :size
      t.boolean :sale, default: false

      t.timestamps
    end
  end
end

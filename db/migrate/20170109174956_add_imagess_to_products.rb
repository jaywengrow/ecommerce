class AddImagessToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :images, :json
  end
end

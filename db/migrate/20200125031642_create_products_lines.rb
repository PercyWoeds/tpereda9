class CreateProductsLines < ActiveRecord::Migration
  def change
    create_table :products_lines do |t|
      t.string :code
      t.string :name
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

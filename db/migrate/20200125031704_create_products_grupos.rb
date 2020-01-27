class CreateProductsGrupos < ActiveRecord::Migration
  def change
    create_table :products_grupos do |t|
      t.string :code
      t.string :name
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

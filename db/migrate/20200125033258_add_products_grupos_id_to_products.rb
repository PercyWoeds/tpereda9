class AddProductsGruposIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :products_grupos_id, :integer
  end
end

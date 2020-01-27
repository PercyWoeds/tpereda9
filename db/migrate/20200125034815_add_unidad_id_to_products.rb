class AddUnidadIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :unidad_id, :integer
  end
end

class AddTipoUnidadIdToTrucks < ActiveRecord::Migration
  def change
    add_column :trucks, :tipo_unidad_id, :integer
   
  end
end

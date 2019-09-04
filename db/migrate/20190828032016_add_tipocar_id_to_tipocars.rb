class AddTipocarIdToTipocars < ActiveRecord::Migration
  def change
    add_column :tipocars, :tipocar_id, :integer
  end
end

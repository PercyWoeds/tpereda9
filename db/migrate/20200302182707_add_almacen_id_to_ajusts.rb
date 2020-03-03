class AddAlmacenIdToAjusts < ActiveRecord::Migration
  def change
    add_column :ajusts, :almacen_id, :integer
  end
end

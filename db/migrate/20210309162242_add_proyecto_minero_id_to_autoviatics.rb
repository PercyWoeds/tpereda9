class AddProyectoMineroIdToAutoviatics < ActiveRecord::Migration
  def change
    add_column :autoviatics, :proyecto_minero_id, :integer
    add_column :autoviatics, :references, :string
    add_column :autoviatics, :proyecto_mineros, :string
  end
end

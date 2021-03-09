class AddProyectoMinero2IdToExmautorizs < ActiveRecord::Migration
  def change
    add_column :exmautorizs, :proyecto_minero2_id, :integer
  end
end

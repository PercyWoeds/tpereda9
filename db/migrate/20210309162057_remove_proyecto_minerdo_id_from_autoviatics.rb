class RemoveProyectoMinerdoIdFromAutoviatics < ActiveRecord::Migration
  def change
    remove_column :autoviatics, :proyecto_minerdo_id, :integer
  end
end

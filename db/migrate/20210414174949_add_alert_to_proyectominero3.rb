class AddAlertToProyectominero3 < ActiveRecord::Migration
  def change
    add_column :proyectominero3s, :alert, :string
  end
end

class AddProyectominero3ToFormatoFecha < ActiveRecord::Migration
  def change
    add_column :proyectominero3s, :formatofecha, :string
    add_column :proyectominero3s, :formatotexto, :string


  end
end

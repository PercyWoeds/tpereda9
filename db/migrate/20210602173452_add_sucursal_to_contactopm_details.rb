class AddSucursalToContactopmDetails < ActiveRecord::Migration
  def change
    add_column :contactopmdetails, :sucursal, :string
  end
end

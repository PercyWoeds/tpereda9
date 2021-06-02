class AddCargoToContactopmDetails < ActiveRecord::Migration
  def change
    add_column :contactopmdetails, :cargo, :string
    add_column :contactopmdetails, :celular, :string
    add_column :contactopmdetails, :observa, :string
  end
end

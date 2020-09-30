class AddOstToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :ost , :string
    add_column :facturas, :manifest_id , :integer 

  end
end

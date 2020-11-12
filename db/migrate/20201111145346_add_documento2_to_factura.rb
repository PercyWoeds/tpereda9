class AddDocumento2ToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :documento2, :string
  end
end

class AddContratoToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :contrato, :string
  end
end

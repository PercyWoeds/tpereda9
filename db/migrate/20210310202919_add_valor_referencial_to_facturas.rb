class AddValorReferencialToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :valor_referencial, :float
  end
end

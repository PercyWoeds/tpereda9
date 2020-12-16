class AddMonedaIdToCotizacion < ActiveRecord::Migration
  def change
    add_column :cotizacions, :moneda_id, :integer
  end
end

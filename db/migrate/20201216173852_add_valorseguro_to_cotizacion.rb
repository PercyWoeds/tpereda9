class AddValorseguroToCotizacion < ActiveRecord::Migration
  def change
    add_column :cotizacions, :valorseguro, :float
  end
end

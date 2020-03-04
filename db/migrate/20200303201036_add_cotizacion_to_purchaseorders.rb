class AddCotizacionToPurchaseorders < ActiveRecord::Migration
  def change
    add_column :purchaseorders, :cotizacion, :string
  end
end

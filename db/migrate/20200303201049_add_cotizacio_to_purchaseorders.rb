class AddCotizacioToPurchaseorders < ActiveRecord::Migration
  def change
    add_column :purchaseorders, :cotiza, :string
    add_column :purchaseorders, :fecha_entrega, :datetime 
    add_column :purchaseorders, :otros, :string
  end
end

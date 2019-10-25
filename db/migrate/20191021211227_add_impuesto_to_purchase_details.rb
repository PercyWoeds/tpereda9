class AddImpuestoToPurchaseDetails < ActiveRecord::Migration
  def change
    add_column :purchase_details, :impuesto, :float
    
  end
end

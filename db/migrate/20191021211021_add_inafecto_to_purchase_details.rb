class AddInafectoToPurchaseDetails < ActiveRecord::Migration
  def change
    add_column :purchase_details, :inafecto, :float
  end
end

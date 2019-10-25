class AddInafectoToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :inafecto, :float
  end
end

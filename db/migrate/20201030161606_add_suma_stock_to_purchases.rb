class AddSumaStockToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :suma_stock, :string
  end
end

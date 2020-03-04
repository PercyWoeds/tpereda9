class AddStockActiveToProducts < ActiveRecord::Migration
  def change
    add_column :products, :stock_active, :string
  end
end

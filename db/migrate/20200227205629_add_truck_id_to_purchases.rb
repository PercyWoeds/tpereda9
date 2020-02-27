class AddTruckIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :truck_id, :integer
  end
end

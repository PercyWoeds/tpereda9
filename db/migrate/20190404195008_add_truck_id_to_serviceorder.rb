class AddTruckIdToServiceorder < ActiveRecord::Migration
  def change
    add_column :serviceorders, :truck_id, :integer
    add_column :serviceorders, :employee_id, :integer
  end
end

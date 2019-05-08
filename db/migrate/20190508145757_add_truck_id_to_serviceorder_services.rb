class AddTruckIdToServiceorderServices < ActiveRecord::Migration
  def change
    add_column :serviceorder_services, :truck_id, :integer
    add_column :serviceorder_services, :employee_id, :integer
  end
end

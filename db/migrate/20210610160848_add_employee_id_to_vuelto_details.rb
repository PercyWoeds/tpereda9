class AddEmployeeIdToVueltoDetails < ActiveRecord::Migration
  def change
    add_column :vuelto_details, :employee_id, :integer
    add_column :vuelto_details, :ubication_id, :integer
	add_column :vuelto_details, :ubication2_id, :integer
	add_column :vuelto_details, :truck_id, :integer
	add_column :vuelto_details, :truck2_id, :integer
	add_column :vuelto_details, :truck3_id, :integer
  end
end

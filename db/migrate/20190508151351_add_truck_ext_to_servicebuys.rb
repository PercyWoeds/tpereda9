class AddTruckExtToServicebuys < ActiveRecord::Migration
  def change
    add_column :servicebuys, :truck_ext, :string
    add_column :servicebuys, :empleado_ext, :string 
    
  end
end

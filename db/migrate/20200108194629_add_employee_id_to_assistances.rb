class AddEmployeeIdToAssistances < ActiveRecord::Migration
  def change
    add_column :assistances, :employee_id, :integer
  end
end

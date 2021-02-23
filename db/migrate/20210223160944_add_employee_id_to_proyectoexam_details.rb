class AddEmployeeIdToProyectoexamDetails < ActiveRecord::Migration
  def change
    add_column :proyectoexam_details, :employee_id, :integer
  end
end

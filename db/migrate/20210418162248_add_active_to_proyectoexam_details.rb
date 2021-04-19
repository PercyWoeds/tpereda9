class AddActiveToProyectoexamDetails < ActiveRecord::Migration
  def change
    add_column :proyectoexam_details, :active, :string
  end
end

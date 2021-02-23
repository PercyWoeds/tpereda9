class AddProyectoExamIdToProyectoexamDetails < ActiveRecord::Migration
  def change
    add_column :proyectoexam_details, :proyecto_exam_id, :integer
  end
end

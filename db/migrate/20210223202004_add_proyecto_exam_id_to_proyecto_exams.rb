class AddProyectoExamIdToProyectoExams < ActiveRecord::Migration
  def change
    add_column :proyecto_exams, :proyecto_exam_id, :integer
  end
end

class RemoveProyectoExamIdFromProyectoExams < ActiveRecord::Migration
  def change
    remove_column :proyecto_exams, :proyecto_exam_id, :integer
  end
end

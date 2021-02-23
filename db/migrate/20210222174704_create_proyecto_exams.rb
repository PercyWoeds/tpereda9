class CreateProyectoExams < ActiveRecord::Migration
  def change
    create_table :proyecto_exams do |t|
      t.integer :employee_id
      t.integer :proyecto_minero_exam_id

      t.timestamps null: false
    end
  end
end

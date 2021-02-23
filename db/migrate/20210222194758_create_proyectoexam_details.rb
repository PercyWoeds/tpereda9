class CreateProyectoexamDetails < ActiveRecord::Migration
  def change
    create_table :proyectoexam_details do |t|
      t.integer :proyecto_minero_exam_id
      t.datetime :fecha
      t.datetime :observacion

      t.timestamps null: false
    end
  end
end

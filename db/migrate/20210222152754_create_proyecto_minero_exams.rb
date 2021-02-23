class CreateProyectoMineroExams < ActiveRecord::Migration
  def change
    create_table :proyecto_minero_exams do |t|
      t.datetime :fecha
      t.string :observacion
      t.string :reference
      t.references :proyecto_minero
      t.references :proyectominero2
      t.references :proyectominero3

      t.timestamps null: false
    end
  end
end

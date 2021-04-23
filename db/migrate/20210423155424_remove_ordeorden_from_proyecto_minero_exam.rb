class RemoveOrdeordenFromProyectoMineroExam < ActiveRecord::Migration
  def change
    remove_column :proyecto_minero_exams, :ordeorden, :string
  end
end

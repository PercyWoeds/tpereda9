class AddOrdenToProyectoMineroExams < ActiveRecord::Migration
  def change
    add_column :proyecto_minero_exams, :ordeorden, :string
  end
end

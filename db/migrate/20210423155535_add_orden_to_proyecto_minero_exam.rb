class AddOrdenToProyectoMineroExam < ActiveRecord::Migration
  def change
    add_column :proyecto_minero_exams, :orden, :integer
  end
end

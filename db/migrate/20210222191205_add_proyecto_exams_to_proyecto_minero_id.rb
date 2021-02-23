class AddProyectoExamsToProyectoMineroId < ActiveRecord::Migration
  def change
    add_column :proyecto_exams, :proyecto_minero_id, :integer
  end
end

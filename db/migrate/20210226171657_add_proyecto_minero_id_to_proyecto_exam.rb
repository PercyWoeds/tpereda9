class AddProyectoMineroIdToProyectoExam < ActiveRecord::Migration
  def change
    add_column :proyectoexam_details, :proyecto_minero_id, :integer
  end
end

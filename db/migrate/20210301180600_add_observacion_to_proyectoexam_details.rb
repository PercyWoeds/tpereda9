class AddObservacionToProyectoexamDetails < ActiveRecord::Migration
  def change
    add_column :proyectoexam_details, :observacion, :string
  end
end

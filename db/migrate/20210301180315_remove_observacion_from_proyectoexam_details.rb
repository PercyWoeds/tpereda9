class RemoveObservacionFromProyectoexamDetails < ActiveRecord::Migration
  def change
    remove_column :proyectoexam_details, :observacion, :datetime
  end
end

class AddProyectoExamToProyectoMineroId < ActiveRecord::Migration
  def change
    add_column :proyecto_mineros, :proyecto_minero_id, :integer
  end
end

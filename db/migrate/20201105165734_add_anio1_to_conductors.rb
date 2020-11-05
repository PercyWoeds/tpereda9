class AddAnio1ToConductors < ActiveRecord::Migration
  def change
    add_column :conductors, :anio1, :string
  end
end

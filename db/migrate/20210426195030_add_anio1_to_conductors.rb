class AddAnio1ToConductors < ActiveRecord::Migration
  def change
    add_column :conductors, :anio1, :string

     add_column :conductors, :anio2, :string
      add_column :conductors, :anio3, :string
       add_column :conductors, :anio4, :string

  end
end

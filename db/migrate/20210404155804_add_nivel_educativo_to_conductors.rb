class AddNivelEducativoToConductors < ActiveRecord::Migration
  def change
    add_column :conductors, :nivel_educativo, :string
  end
end

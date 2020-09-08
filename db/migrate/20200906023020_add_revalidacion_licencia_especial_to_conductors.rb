class AddRevalidacionLicenciaEspecialToConductors < ActiveRecord::Migration
  def change
    add_column :conductors, :revalidacion_licencia_especial, :datetime
  end
end

class AddCotizacionToManifest < ActiveRecord::Migration
  def change
    add_column :manifests, :cotizacion, :string

    
  end
end

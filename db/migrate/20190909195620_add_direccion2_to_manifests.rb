class AddDireccion2ToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :direccion2, :string
  end
end

class AddDireccion1ToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :direccion1, :string
  end
end

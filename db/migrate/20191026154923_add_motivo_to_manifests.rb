class AddMotivoToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :motivo, :string
  end
end

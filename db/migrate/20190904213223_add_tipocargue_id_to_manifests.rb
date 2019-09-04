class AddTipocargueIdToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :tipocargue_id, :integer
    add_column :manifests, :references, :string
    add_column :manifests, :manifest, :string
  end
end

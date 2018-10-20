class AddLocationIdToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :location_id, :integer
  end
end

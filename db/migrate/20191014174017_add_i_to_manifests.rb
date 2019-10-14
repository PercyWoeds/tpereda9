class AddIToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :i, :integer
  end
end

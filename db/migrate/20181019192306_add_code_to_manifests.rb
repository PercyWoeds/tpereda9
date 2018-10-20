class AddCodeToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :code, :string
  end
end

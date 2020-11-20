class AddYearMounthToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :year_mounth, :string
  end
end

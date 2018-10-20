class AddUserIdToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :user_id, :integer
  end
end

class AddHoraToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :hora, :string
  end
end

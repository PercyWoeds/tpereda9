class AddImporte2ToManifest < ActiveRecord::Migration
  def change
    add_column :manifests, :importe2, :float
  end
end

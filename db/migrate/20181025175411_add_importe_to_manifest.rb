class AddImporteToManifest < ActiveRecord::Migration
  def change
    add_column :manifests, :importe, :float
  end
end

class AddEmpaletizadoToManifest < ActiveRecord::Migration
  def change
    add_column :manifests, :empaletizado, :float
    add_column :manifests, :montacarga, :float
    add_column :manifests, :escolta, :float
    add_column :manifests, :stand_by, :float
    
  end
end

class AddProcessedToManifests < ActiveRecord::Migration
  def change
    add_column :manifests, :processed, :string
    add_column :manifests, :date_processed, :datetime 
    
  end
end

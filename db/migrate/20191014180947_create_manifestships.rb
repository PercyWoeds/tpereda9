class CreateManifestships < ActiveRecord::Migration
  def change
    create_table :manifestships do |t|
      t.integer :tranportorder_id
      t.integer :manifest_id

      t.timestamps null: false
    end
  end
end

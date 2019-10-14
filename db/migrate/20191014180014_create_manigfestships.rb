class CreateManigfestships < ActiveRecord::Migration
  def change
    create_table :manigfestships do |t|
      t.integer :tranportorder_id
      t.integer :manifest_id

      t.timestamps null: false
    end
  end
end

class CreateStsships < ActiveRecord::Migration
  def change
    create_table :stsships do |t|
      t.integer :factura_id
      t.integer :manifest_id

      t.timestamps null: false
    end
  end
end

class CreateLvtDetails < ActiveRecord::Migration
  def change
    create_table :lvt_details do |t|
      t.datetime :fecha
      t.integer :gasto_id
      t.integer :document_id
      t.string :documento
      t.float :total
      t.integer :lvt_id
      t.integer :supplier_id
      t.string :td
      t.string :detalle

      t.timestamps null: false
    end
  end
end

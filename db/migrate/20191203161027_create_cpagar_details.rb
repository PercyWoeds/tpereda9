class CreateCpagarDetails < ActiveRecord::Migration
  def change
    create_table :cpagar_details do |t|
      t.integer :document_id
      t.string :documento
      t.integer :supplier_id
      t.string :tm
      t.float :total
      t.text :descrip
      t.references :cpagar, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

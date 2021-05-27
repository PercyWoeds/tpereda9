class CreateVueltoDetails < ActiveRecord::Migration
  def change
    create_table :vuelto_details do |t|
      t.datetime :fecha
      t.integer :cout_id
      t.float :importe
      t.float :flete
      t.float :egreso
      t.float :total
      t.text :observa
      t.references :vuelto, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

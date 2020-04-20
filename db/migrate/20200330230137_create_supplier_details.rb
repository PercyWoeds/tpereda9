class CreateSupplierDetails < ActiveRecord::Migration
  def change
    create_table :supplier_details do |t|
      t.string :name
      t.string :cargo
      t.string :telefono
      t.string :correo
      t.string :area
      t.references :supplier, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

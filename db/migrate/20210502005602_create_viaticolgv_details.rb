class CreateViaticolgvDetails < ActiveRecord::Migration
  def change
    create_table :viaticolgv_details do |t|
      t.integer :viatico_id
      t.datetime :fecha
      t.text :descrip
      t.integer :document_id
      t.string :numero
      t.float :importe
      t.text :detalle
      t.string :tm
      t.float :CurrTotal
      t.integer :tranportorder_id
      t.datetime :date_processed
      t.string :ruc
      t.integer :supplier_id
      t.integer :gasto_id
      t.integer :employee_id
      t.integer :destino_id
      t.integer :egreso_id
      t.references :viaticolgv, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

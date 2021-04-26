class CreateViaticotbkDetails < ActiveRecord::Migration
  def change
    create_table :viaticotbk_details do |t|
      t.integer :viaticotbk_id
      t.datetime :fecha
      t.text :descrip
      t.integer :document_id
      t.string :numero
      t.float :importe
      t.text :detalle
      t.string :tm
      t.string :CurrTotal
      t.integer  :tranportorder_id
      t.datetime :date_processed
      t.string   :ruc
      t.integer  :supplier_id
      t.integer  :gasto_id
      t.integer  :employee_id
      t.integer  :destino_id
      t.integer  :egreso_id

      t.timestamps null: false
    end
  end
end

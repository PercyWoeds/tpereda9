class CreatePaymentnoticeDetails < ActiveRecord::Migration
  def change
    create_table :paymentnotice_details do |t|
      t.datetime :fecha_inicio
      t.datetime :fecha_culmina
      t.float :total
      t.string :descrip
      t.string :lugar
      t.float :price_unit
      t.float :sub_total
      t.float :igv
      t.float :total
      t.string :nro_compro
      t.string :nro_documento
      t.string :observa
    

      t.timestamps null: false
    end
  end
end

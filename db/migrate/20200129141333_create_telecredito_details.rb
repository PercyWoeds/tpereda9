class CreateTelecreditoDetails < ActiveRecord::Migration
  def change
    create_table :telecredito_details do |t|
      t.datetime :fecha
      t.string :nro
      t.string :operacion
      t.integer :purchase_id
      t.string :beneficiario
      t.string :documento
      t.string :moneda
      t.float :importe
      t.float :egreso
      t.string :aprueba
      t.string :observacion
      t.integer :telecredito_id

      t.timestamps null: false
    end
  end
end

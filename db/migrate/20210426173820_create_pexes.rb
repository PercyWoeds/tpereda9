class CreatePexes < ActiveRecord::Migration
  def change
    create_table :pexes do |t|
      t.string :doc
      t.string :razon
      t.string :red
      t.string :ruc_red
      t.string :placa
      t.string :nromiddia
      t.string :categoria
      t.string :fecha_inicio
      t.string :hora_inicio
      t.string :fecha_fin
      t.string :hora_fin
      t.string :fecha_apro
      t.string :hora_apro
      t.string :plaza
      t.string :pista
      t.float :importe
      t.string :nro_compro
      t.string :fecha_compro

      t.timestamps null: false
    end
  end
end

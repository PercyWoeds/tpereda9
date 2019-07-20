class CreateLgcs < ActiveRecord::Migration
  def change
    create_table :lgcs do |t|
      t.integer :employee_id
      t.integer :placa_id
      t.integer :placa_id2
      t.float :peso_ida
      t.float :peso_ret
      t.integer :tipo_carga_id
      t.string :ruta
      t.datetime :viaje_salida_fecha
      t.datetime :viaje_retorno_fecha
      t.string :recorrido
      t.string :float
      t.float :salida_km
      t.float :retorno_km
      t.float :km_real
      t.float :total_gal
      t.float :ratio_fisico
      t.float :ratio_teorico
      t.float :idle_fuel
      t.time :idletime
      t.float :time_1
      t.float :margen
      t.float :dscto_gln
      t.float :monto
      t.float :rpm
      t.float :km
      t.float :abas_total
      t.float :monto_total
      t.text :obser
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

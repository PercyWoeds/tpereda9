class CreateAutoviatics < ActiveRecord::Migration
  def change
    create_table :autoviatics do |t|
      t.integer :location_id
      t.integer :proyecto_minerdo_id
      t.integer :employee_id
      t.datetime :fecha
      t.text :tema
      t.integer :supplier_id
      t.string :asunto
      t.integer :tramit_id
      t.float :movilidad
      t.float :almuerzo
      t.float :otros
      t.string :lugar1
      t.string :lugar2
      t.string :lugar3
      t.text :obser
      t.string :lugar_salida
      t.string :lugar_salida2
      t.time :hora_ingreso
      t.time :hora_salida
      t.text :obser2
      t.string :processed
      t.datetime :date_processed

      t.timestamps null: false
    end
  end
end

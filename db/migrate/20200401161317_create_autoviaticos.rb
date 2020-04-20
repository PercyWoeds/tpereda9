class CreateAutoviaticos < ActiveRecord::Migration
  def change
    create_table :autoviaticos do |t|
      t.string :code
      t.integer :employee_id
      t.datetime :fecha
      t.string :tema
      t.integer :supplier_id
      t.string :asunto
      t.float :movilidad
      t.float :almuerzo
      t.float :otros
      t.string :observa
      t.string :hora_ingreso
      t.string :hora_salida
      t.integer :employee_id2
      t.string :lugar_salida
      t.string :lugar_destino
      t.string :hora1
      t.string :hora2
      t.string :observa2

      t.timestamps null: false
    end
  end
end

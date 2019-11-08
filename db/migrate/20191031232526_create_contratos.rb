class CreateContratos < ActiveRecord::Migration
  def change
    create_table :contratos do |t|
      t.integer :employee_id
      t.datetime :fecha_inicio
      t.datetime :fecha_fin
      t.datetime :fecha_suscripcion
      t.integer :location_id
      t.integer :division_id
      t.float :sueldo
      t.string :reingreso
      t.text :comments
      t.integer :modalidad_id
      t.integer :tipocontrato_id
      t.integer :submodalidad_id
      t.integer :moneda_id
      t.integer :tiporemuneracion_id

      t.timestamps null: false
    end
  end
end

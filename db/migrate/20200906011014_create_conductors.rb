class CreateConductors < ActiveRecord::Migration
  def change
    create_table :conductors do |t|
      t.string :lugar
      t.string :anio
      t.string :licencia
      t.string :categoria
      t.datetime :expedicion_licencia
      t.datetime :revalidacion_licencia
      t.string :categoria_especial
      t.datetime :expedicion_licencia_especial
      t.string :iqbf
      t.datetime :fecha_emision
      t.datetime :dni_emision
      t.datetime :dni_caducidad
      t.datetime :ap_emision
      t.datetime :ap_caducidad
      t.datetime :ape_emision
      t.datetime :ape_caducidad
      t.integer :user_id
      t.integer :company_id
      t.integer :employee_id 
      t.string :active
      t.references :employees, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

class CreateCdocuments < ActiveRecord::Migration
  def change
    create_table :cdocuments do |t|
      t.integer :employee_id
      t.string :lugar
      t.string :experiencia
      t.string :dni
      t.string :categoria
      t.string :exp_licencia
      t.string :rev_licencia
      t.string :categoria_especial
      t.string :exp_licencia2
      t.string :rev_licencia
      t.string :iqbf
      t.datetime :dni_emision
      t.datetime :dni_caducidad
      t.datetime :ap_emision
      t.datetime :ap_caducidad
      t.datetime :app_emision
      t.datetime :app_caducidad
      t.text :cv_documentado
      t.string :nivel_educativo

      t.timestamps null: false
    end
  end
end

class CreateProgramExms < ActiveRecord::Migration
  def change
    create_table :program_exms do |t|
      t.integer :employee_id
      t.string :ind
      t.string :tr
      t.string :em
      t.string :lo
      t.string :tema
      t.datetime :fecha
      t.time :inicio
      t.time :termino
      t.time :totalhora
      t.time :horaingbase
      t.text :observa

      t.timestamps null: false
    end
  end
end

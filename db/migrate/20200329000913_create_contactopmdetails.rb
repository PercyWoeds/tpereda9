class CreateContactopmdetails < ActiveRecord::Migration
  def change
    create_table :contactopmdetails do |t|
      t.string :contacto
      t.string :email
      t.string :telefono
      t.references :contactopm, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

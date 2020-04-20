class CreateProyectoMineros < ActiveRecord::Migration
  def change
    create_table :proyecto_mineros do |t|
      t.string :code
      t.datetime :fecha1
      t.datetime :fecha2
      t.string :descrip
      t.integer :punto_id

      t.timestamps null: false
    end
  end
end

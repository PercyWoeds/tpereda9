class CreateMntos < ActiveRecord::Migration
  def change
    create_table :mntos do |t|
      t.string :code
      t.integer :division_id
      t.integer :ocupacion_id
      t.datetime :fecha
      t.integer :truck_id
      t.float :km_programado
      t.float :km_actual
      t.datetime :fecha2
      t.integer :user_id
      t.string :processed
      t.datetime :date_processed
      t.string :tipo 

      t.timestamps null: false
    end
  end
end

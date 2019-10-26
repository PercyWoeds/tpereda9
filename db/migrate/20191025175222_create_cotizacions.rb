class CreateCotizacions < ActiveRecord::Migration
  def change
    create_table :cotizacions do |t|
      t.datetime :fecha
      t.string :code
      t.integer :customer_id
      t.integer :punto_id
      t.integer :punto2_id
      t.integer :tipocargue_id
      t.float :tarifa
      t.string :processed
      t.string :comments

      t.timestamps null: false
    end
  end
end

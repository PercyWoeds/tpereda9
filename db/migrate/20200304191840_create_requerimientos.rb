class CreateRequerimientos < ActiveRecord::Migration
  def change
    create_table :requerimientos do |t|
      t.string :code
      t.integer :employee_id
      t.integer :division_id
      t.datetime :fecha
      t.string :hora

      t.string  :item_1
      t.string  :codigo_1
      t.integer :cantidad_1
      t.string  :unidad_1
      t.string  :descrip_1
      t.string  :placa_1
      t.string  :descrip_1


      t.string  :item_2
      t.string  :codigo_2
      t.integer :cantidad_2
      t.string  :unidad_2
      t.string  :descrip_2
      t.string  :placa_2
      t.string  :descrip_2


      t.string  :item_3
      t.string  :codigo_3
      t.integer :cantidad_3
      t.string  :unidad_3
      t.string  :descrip_3
      t.string  :placa_3
      t.string  :descrip_3


      t.string  :item_4
      t.string  :codigo_4
      t.integer :cantidad_4
      t.string  :unidad_4
      t.string  :descrip_4
      t.string  :placa_4
      t.string  :descrip_4


      t.string  :item_5
      t.string  :codigo_5
      t.integer :cantidad_5
      t.string  :unidad_5
      t.string  :descrip_5
      t.string  :placa_5
      t.string  :descrip_5


      t.string  :item_5
      t.string  :codigo_5
      t.integer :cantidad_5
      t.string  :unidad_5
      t.string  :descrip_5
      t.string  :placa_5
      t.string  :descrip_5


      t.string  :item_6
      t.string  :codigo_6
      t.integer :cantidad_6
      t.string  :unidad_6
      t.string  :descrip_6
      t.string  :placa_6
      t.string  :descrip_6



      t.string  :item_7
      t.string  :codigo_7
      t.integer :cantidad_7
      t.string  :unidad_7
      t.string  :descrip_7
      t.string  :placa_7
      t.string  :descrip_7


      t.string  :item_8
      t.string  :codigo_8
      t.integer :cantidad_8
      t.string  :unidad_8
      t.string  :descrip_8
      t.string  :placa_8
      t.string  :descrip_8


      t.string  :item_9
      t.string  :codigo_9
      t.integer :cantidad_9
      t.string  :unidad_9
      t.string  :descrip_9
      t.string  :placa_9
      t.string  :descrip_9


      t.string  :item_10
      t.string  :codigo_10
      t.integer :cantidad_10
      t.string  :unidad_10
      t.string  :descrip_10
      t.string  :placa_10
      t.string  :descrip_10



      t.text :nota
      t.text :observa

      t.timestamps null: false
    end
  end
end

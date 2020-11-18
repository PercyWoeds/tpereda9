class CreateCouts < ActiveRecord::Migration
  def change
    create_table :couts do |t|
      t.string :code
      t.datetime :fecha
      t.float :importe
      t.integer :truck_id
      t.integer :punto_id
      t.integer :tranportorder_id
      t.integer :employee_id
      t.integer :employee2_id
      t.integer :employee3_id
      t.float :peajes
      t.float :lavado
      t.float :llanta
      t.float :alimento
      t.float :otros
      t.float :monto_recibido
      t.float :flete
      t.float :recibido_ruta
      t.float :vuelto
      t.float :descuento
      t.float :reembolso
      t.float :flete
      t.integer :ost_id

      t.timestamps null: false
    end
  end
end

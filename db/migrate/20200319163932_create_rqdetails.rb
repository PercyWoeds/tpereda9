class CreateRqdetails < ActiveRecord::Migration
  def change
    create_table :rqdetails do |t|
      t.integer :requerimiento_id
      t.string :codigo
      t.float :qty
      t.integer :unidad_id
      t.string :descrip
      t.string :placa_destino
      t.string :string

      t.timestamps null: false
    end
  end
end

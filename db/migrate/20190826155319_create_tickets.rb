class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.datetime :fecha
      t.integer :eess_id
      t.integer :truck_id
      t.integer :product_id
      t.float :quantity
      t.float :precioigv
      t.float :importe
      t.integer :employee_id
      t.datetime :fecha_fact
      t.integer :factura_id
      t.integer :supplier_id
      t.integer :card_id

      t.timestamps null: false
    end
  end
end

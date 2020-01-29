class CreateFreepagars < ActiveRecord::Migration
  def change
    create_table :freepagars do |t|
      t.integer :supplier_id
      t.float :anio01
      t.float :anio02
      t.float :anio03
      t.float :anio04
      t.float :anio05
      t.float :anio06
      t.float :anio07
      t.float :general
      t.float :cantidad
      t.float :compras
      t.float :compras_cant
      t.float :total_gral
      t.float :cant_fact
      t.float :vmto
      t.float :xpagar
      t.float :detraccion
      t.float :saldo

      t.timestamps null: false
    end
  end
end

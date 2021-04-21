class CreateLvts < ActiveRecord::Migration
  def change
    create_table :lvts do |t|
      t.string :code
      t.integer :tranportorder_id
      t.datetime :fecha
      t.integer :viatico_id
      t.float :total
      t.string :devuelto_texto
      t.float :devuelto
      t.float :reembolso
      t.float :descuento
      t.text :observa
      t.integer :company_id
      t.string :processed
      t.integer :user_id
      t.integer :tranportorder_id
      t.text :comments
      t.integer :gasto_id
      t.integer :compro_id
      t.float :inicial
      t.float :total_ing
      t.float :total_egreso
      t.float :saldo
      t.integer :lgv_id
      t.float :peaje
      t.string :cdevuelto
      t.string :cdescuento
      t.string :creembolso

      t.timestamps null: false
    end
  end
end

class CreateViaticotbks < ActiveRecord::Migration
  def change
    create_table :viaticotbks do |t|
      t.string :code
      t.datetime :fecha1
      t.float :inicial
      t.float :total_ing
      t.float :total_egreso
      t.float :saldo
      t.string :comments
      t.integer :user_id
      t.integer :company_id
      t.string :processed
      t.integer :compro_id
      t.datetime :date_processed
      t.string :tipo
      t.integer :caja_id
      t.string :cdevuelto
      t.string :cdescuento
      t.string :creembolso

      t.timestamps null: false
    end
  end
end

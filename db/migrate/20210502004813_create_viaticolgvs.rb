class CreateViaticolgvs < ActiveRecord::Migration
  def change
    create_table :viaticolgvs do |t|
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
      t.datetime :fecha_devuelto
      t.datetime :fecha_descuento
      t.datetime :fecha_reembolso
      t.float :cdevuelto_importe
      t.float :cdescuento_importe
      t.float :creembolso_importe

      t.timestamps null: false
    end
  end
end

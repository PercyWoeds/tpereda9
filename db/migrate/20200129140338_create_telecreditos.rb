class CreateTelecreditos < ActiveRecord::Migration
  def change
    create_table :telecreditos do |t|
      t.datetime :fecha1
      t.datetime :fecha2
      t.string :code
      t.integer :bank_acount_id
      t.float :importe

      t.timestamps null: false
    end
  end
end

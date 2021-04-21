class CreateLvtDeliveries < ActiveRecord::Migration
  def change
    create_table :lvt_deliveries do |t|
      t.integer :lvt_id
      t.float :importe
      t.integer :compro_id

      t.timestamps null: false
    end
  end
end

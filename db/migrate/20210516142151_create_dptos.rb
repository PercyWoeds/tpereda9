class CreateDptos < ActiveRecord::Migration
  def change
    create_table :dptos do |t|
      t.string :code
      t.string :name
      t.string :ubigeo

      t.timestamps null: false
    end
  end
end

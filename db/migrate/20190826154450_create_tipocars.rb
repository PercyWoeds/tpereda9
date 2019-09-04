class CreateTipocars < ActiveRecord::Migration
  def change
    create_table :tipocars do |t|
      t.string :code
      t.string :nombre

      t.timestamps null: false
    end
  end
end

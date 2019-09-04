class CreateEesses < ActiveRecord::Migration
  def change
    create_table :eesses do |t|
      t.string :code
      t.string :nombre
      t.string :address

      t.timestamps null: false
    end
  end
end

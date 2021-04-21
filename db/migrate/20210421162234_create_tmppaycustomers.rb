class CreateTmppaycustomers < ActiveRecord::Migration
  def change
    create_table :tmppaycustomers do |t|
      t.string :item
      t.string :customer
      t.float :c_1
      t.float :c_2
      t.float :c_3
      t.float :c_4
      t.float :c_5
      t.float :c_6
      t.float :c_7
      t.float :c_8
      t.float :c_9
      t.float :c_10
      t.float :c_11
      t.float :c_12
      t.float :c_13
      t.float :c_14

      t.timestamps null: false
    end
  end
end

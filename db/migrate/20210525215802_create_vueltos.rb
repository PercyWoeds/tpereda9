class CreateVueltos < ActiveRecord::Migration
  def change
    create_table :vueltos do |t|
      t.string :code
      t.datetime :fecha
      t.integer :user_id
      t.string :processed
      t.datetime :date_processed
      t.float :total

      t.timestamps null: false
    end
  end
end

class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :code
      t.string :name
      t.string :extra

      t.timestamps null: false
    end
  end
end

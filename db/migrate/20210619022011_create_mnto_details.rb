class CreateMntoDetails < ActiveRecord::Migration
  def change
    create_table :mnto_details do |t|
      t.integer :activity_id
      t.string :process
      t.references :mnto, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

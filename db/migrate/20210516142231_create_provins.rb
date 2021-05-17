class CreateProvins < ActiveRecord::Migration
  def change
    create_table :provins do |t|
      t.string :code
      t.string :name
      t.string :ubigeo

      t.timestamps null: false
    end
  end
end

class CreateProyectominero3s < ActiveRecord::Migration
  def change
    create_table :proyectominero3s do |t|
      t.string :code
      t.string :name
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

class CreateProyectominero2s < ActiveRecord::Migration
  def change
    create_table :proyectominero2s do |t|
      t.string :code
      t.string :name
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

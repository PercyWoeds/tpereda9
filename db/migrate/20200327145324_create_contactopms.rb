class CreateContactopms < ActiveRecord::Migration
  def change
    create_table :contactopms do |t|
      t.integer :proyecto_minero_id

      t.timestamps null: false
    end
  end
end

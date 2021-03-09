class CreateTramits < ActiveRecord::Migration
  def change
    create_table :tramits do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end

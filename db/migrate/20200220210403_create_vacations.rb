class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.integer :employee_id
      t.datetime :fecha1
      t.datetime :fecha2
      t.text :observa

      t.timestamps null: false
    end
  end
end

class CreateHorasMes < ActiveRecord::Migration
  def change
    create_table :horas_mes do |t|
      t.float :dt
      t.float :fal
      t.float :sub
      t.float :dm
      t.float :pat
      t.float :vac
      t.float :tot
      t.integer :payroll_id
      t.integer :employee_id

      t.timestamps null: false
    end
  end
end

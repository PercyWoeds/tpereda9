class AddHoraExToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :hora_ex, :float
  end
end

class AddEfectivoToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :efectivo, :float
  end
end

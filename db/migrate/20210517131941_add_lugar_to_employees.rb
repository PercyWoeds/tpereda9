class AddLugarToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :lugar, :string
  end
end

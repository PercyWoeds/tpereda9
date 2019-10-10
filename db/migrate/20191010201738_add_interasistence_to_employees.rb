class AddInterasistenceToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :interasistence, :string
  end
end

class AddDptoIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :dpto_id, :integer
	add_column :employees, :provin_id, :integer
	add_column :employees, :distrito_id, :integer

  end
end

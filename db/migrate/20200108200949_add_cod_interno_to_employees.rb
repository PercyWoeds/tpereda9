class AddCodInternoToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :cod_interno, :string
  end
end

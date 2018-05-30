class AddCuentaBancariaToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :cuenta_bancaria, :string
  end
end

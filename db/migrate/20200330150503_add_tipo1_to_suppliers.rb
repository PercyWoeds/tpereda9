class AddTipo1ToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :tipo1, :string
    add_column :suppliers, :tipo2, :string

  end
end

class AddTipoexmToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :tipoexm, :string
  end
end

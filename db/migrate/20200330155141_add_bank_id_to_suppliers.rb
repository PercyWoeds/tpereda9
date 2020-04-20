class AddBankIdToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :bank_id, :integer
    add_column :suppliers, :cuenta_corriente, :string
    add_column :suppliers, :proyecto_minero, :string
  
  end
end

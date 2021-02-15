class AddSupplierTypeIdToSuppliers < ActiveRecord::Migration
  def change
    add_column :suppliers, :supplier_type_id, :integer
  end
end

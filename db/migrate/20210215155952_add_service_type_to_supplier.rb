class AddServiceTypeToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :service_type, :string
  end
end

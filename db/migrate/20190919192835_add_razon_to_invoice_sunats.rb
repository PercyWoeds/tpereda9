class AddRazonToInvoiceSunats < ActiveRecord::Migration
  def change
    add_column :invoicesunats, :razon, :string
  end
end

class AddCustomerIdToTranportorders < ActiveRecord::Migration
  def change
    add_column :tranportorders, :customer_id, :string
  
  end
end

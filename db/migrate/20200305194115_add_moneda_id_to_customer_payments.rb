class AddMonedaIdToCustomerPayments < ActiveRecord::Migration
  def change
    add_column :customer_payments, :moneda_id, :integer
  end
end

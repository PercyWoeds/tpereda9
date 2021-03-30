class AddSupplierIdToPaymentNotices < ActiveRecord::Migration
  def change
    add_column :payment_notices, :supplier_id, :integer
  end
end

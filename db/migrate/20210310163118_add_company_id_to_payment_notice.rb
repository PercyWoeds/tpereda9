class AddCompanyIdToPaymentNotice < ActiveRecord::Migration
  def change
    add_column :payment_notices, :company_id, :integer
  end
end

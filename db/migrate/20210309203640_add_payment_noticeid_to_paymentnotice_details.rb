class AddPaymentNoticeidToPaymentnoticeDetails < ActiveRecord::Migration
  def change
    add_column :paymentnotice_details, :payment_notice_id , :integer 
  end
end

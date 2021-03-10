class AddQtyToPaymentnoticeDetails < ActiveRecord::Migration
  def change
    add_column :paymentnotice_details, :qty, :float
  end
end

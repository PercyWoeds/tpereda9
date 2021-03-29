class AddProyectoMineroIdToPaymentnoticeDetails < ActiveRecord::Migration
  def change
    add_column :paymentnotice_details, :proyecto_minero_id, :integer
  end
end

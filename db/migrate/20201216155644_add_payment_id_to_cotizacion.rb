class AddPaymentIdToCotizacion < ActiveRecord::Migration
  def change
    add_column :cotizacions, :payment_id, :integer
  end
end

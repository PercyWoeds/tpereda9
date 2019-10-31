class AddPagosToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :pagos, :float
  end
end

class AddAlmacenIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :almacen_id, :integer
  end
end

class AddOscustomerToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :os_customer, :text
  end
end

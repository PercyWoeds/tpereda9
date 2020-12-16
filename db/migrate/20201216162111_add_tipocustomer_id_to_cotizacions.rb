class AddTipocustomerIdToCotizacions < ActiveRecord::Migration
  def change
    add_column :cotizacions, :tipocustomer_id, :integer
  end
end

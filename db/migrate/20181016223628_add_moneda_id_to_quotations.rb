class AddMonedaIdToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :moneda_id, :integer
  end
end

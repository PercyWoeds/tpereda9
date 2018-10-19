class AddDolarToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :dolar, :float
  end
end

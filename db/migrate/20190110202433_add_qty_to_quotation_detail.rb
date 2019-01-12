class AddQtyToQuotationDetail < ActiveRecord::Migration
  def change
    add_column :quotation_details, :qty, :float
  end
end

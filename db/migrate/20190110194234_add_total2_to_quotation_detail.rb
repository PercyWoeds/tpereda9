class AddTotal2ToQuotationDetail < ActiveRecord::Migration
  def change
    add_column :quotation_details, :total2, :float
  end
end

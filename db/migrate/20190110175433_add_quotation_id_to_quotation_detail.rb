class AddQuotationIdToQuotationDetail < ActiveRecord::Migration
  def change
    add_column :quotation_details, :quotation_id, :integer
  end
end

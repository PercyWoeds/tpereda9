class AddItemToQuotationDetails < ActiveRecord::Migration
  def change
    add_column :quotation_details, :item, :integer
  end
end

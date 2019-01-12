class RemoveItemToQuotationDetails < ActiveRecord::Migration
  def change
    remove_column :quotation_details, :item, :string
  end
end

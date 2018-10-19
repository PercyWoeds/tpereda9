class AddDateProcessedToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :date_processed, :string
  end
end

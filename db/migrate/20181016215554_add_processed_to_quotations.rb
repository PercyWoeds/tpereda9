class AddProcessedToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :processed, :string
  end
end

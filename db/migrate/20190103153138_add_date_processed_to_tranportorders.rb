class AddDateProcessedToTranportorders < ActiveRecord::Migration
  def change
    add_column :tranportorders, :date_processed, :datetime
  end
end

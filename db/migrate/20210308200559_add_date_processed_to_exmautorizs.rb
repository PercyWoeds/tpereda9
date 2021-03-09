class AddDateProcessedToExmautorizs < ActiveRecord::Migration
  def change
    add_column :exmautorizs, :date_processed, :datetime
  end
end

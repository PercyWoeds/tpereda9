class AddDateProcessedToAutoviaticos < ActiveRecord::Migration
  def change
    add_column :autoviaticos, :date_processed, :datetime
  end
end

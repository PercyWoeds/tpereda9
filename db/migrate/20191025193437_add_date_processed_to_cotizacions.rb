class AddDateProcessedToCotizacions < ActiveRecord::Migration
  def change
    add_column :cotizacions, :date_processed, :datetime
  end
end

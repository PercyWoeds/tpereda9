class AddDateProcessedToRequerimiento < ActiveRecord::Migration
  def change
    add_column :requerimientos, :date_processed, :datetime
  end
end

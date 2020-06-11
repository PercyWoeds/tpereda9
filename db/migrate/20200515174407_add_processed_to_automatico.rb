class AddProcessedToAutomatico < ActiveRecord::Migration
  def change
    add_column :autoviaticos, :processed, :string
  end
end

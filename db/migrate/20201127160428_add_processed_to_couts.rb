class AddProcessedToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :processed, :string
  end
end

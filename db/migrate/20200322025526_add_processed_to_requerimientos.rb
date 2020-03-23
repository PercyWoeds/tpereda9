class AddProcessedToRequerimientos < ActiveRecord::Migration
  def change
    add_column :requerimientos, :processed, :string
  end
end

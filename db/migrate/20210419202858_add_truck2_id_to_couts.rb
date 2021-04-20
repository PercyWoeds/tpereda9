class AddTruck2IdToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :truck2_id, :integer

    add_column :couts, :truck3_id, :integer

    
  end
end

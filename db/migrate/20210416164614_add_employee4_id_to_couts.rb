class AddEmployee4IdToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :employee4_id, :integer
    add_column :couts, :observa , :text

  end
end

class AddIToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :i, :integer
  end
end

class AddParentToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :parent, :string
  end
end

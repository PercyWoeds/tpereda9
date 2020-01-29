class AddDate4ToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :date4, :datetime
  end
end

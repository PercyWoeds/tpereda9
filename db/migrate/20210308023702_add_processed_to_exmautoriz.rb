class AddProcessedToExmautoriz < ActiveRecord::Migration
  def change
    add_column :exmautorizs, :processed, :string
    add_column :exmautorizs, :comments , :string
    
  end
end

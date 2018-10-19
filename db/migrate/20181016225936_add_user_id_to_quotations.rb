class AddUserIdToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :user_id, :integer
  end
end

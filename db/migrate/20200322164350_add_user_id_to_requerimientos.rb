class AddUserIdToRequerimientos < ActiveRecord::Migration
  def change
    add_column :requerimientos, :user_id, :integer
  end
end

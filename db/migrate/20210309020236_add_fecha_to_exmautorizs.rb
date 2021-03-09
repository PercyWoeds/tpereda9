class AddFechaToExmautorizs < ActiveRecord::Migration
  def change
    add_column :exmautorizs, :fecha, :datetime
  end
end

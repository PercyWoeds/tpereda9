class AddTruck3ToTranportorders < ActiveRecord::Migration
  def change
    add_column :tranportorders, :truck3_id, :integer
  end
end

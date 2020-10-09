class AddEmployee4IdToTranportorders < ActiveRecord::Migration
  def change
    add_column :tranportorders, :employee4_id, :integer
  end
end

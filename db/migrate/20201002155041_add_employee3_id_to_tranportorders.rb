class AddEmployee3IdToTranportorders < ActiveRecord::Migration
  def change
    add_column :tranportorders, :employee3_id, :integer
  end
end

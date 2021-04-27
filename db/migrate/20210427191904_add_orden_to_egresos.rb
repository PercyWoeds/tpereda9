class AddOrdenToEgresos < ActiveRecord::Migration
  def change
    add_column :egresos, :orden, :integer
  end
end

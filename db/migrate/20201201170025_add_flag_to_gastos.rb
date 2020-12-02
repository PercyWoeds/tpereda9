class AddFlagToGastos < ActiveRecord::Migration
  def change
    add_column :gastos, :flag, :string
  end
end

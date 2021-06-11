class AddObservaToVueltos < ActiveRecord::Migration
  def change
    add_column :vueltos, :observa, :text
  end
end

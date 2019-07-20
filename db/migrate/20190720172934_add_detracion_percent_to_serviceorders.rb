class AddDetracionPercentToServiceorders < ActiveRecord::Migration
  def change
    add_column :serviceorders, :detracion_percent, :float
  end
end

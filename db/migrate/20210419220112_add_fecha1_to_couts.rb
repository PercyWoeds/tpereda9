class AddFecha1ToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :fecha1, :datetime

      add_column :couts, :fecha2, :datetime

  end
end

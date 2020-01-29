class AddAnio00ToFreepagar < ActiveRecord::Migration
  def change
    add_column :freepagars, :anio00, :float
  end
end

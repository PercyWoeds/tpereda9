class AddEgresoIdToEgresos < ActiveRecord::Migration
  def change
    add_column :egresos, :egreso_id, :integer
  end
end

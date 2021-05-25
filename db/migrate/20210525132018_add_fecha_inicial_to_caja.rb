class AddFechaInicialToCaja < ActiveRecord::Migration
  def change
    add_column :cajas, :fecha_inicial, :datetime
    add_column :cajas, :saldo_inicial, :float
    
  end
end

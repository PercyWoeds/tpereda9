class AddSaldoEgresoToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :importe_saldo_egreso, :float
  end
end

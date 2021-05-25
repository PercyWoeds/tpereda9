class AddFechaSaldoAntToViaticos < ActiveRecord::Migration
  def change
    add_column :viaticos, :fecha_saldo_ant,     :datetime
    add_column :viaticos, :fecha_saldo_final,   :datetime
    add_column :viaticos, :importe_saldo_ant,   :float 
    add_column :viaticos, :importe_saldo_final, :float
    add_column :viaticos, :importe_documento,   :float 

  end
end

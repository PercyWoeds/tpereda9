class AddFecha2ToAutoviaticos < ActiveRecord::Migration
  def change
    add_column :autoviaticos, :fecha2, :datetime
  end
end

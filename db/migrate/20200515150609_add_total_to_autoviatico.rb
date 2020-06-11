class AddTotalToAutoviatico < ActiveRecord::Migration
  def change
    add_column :autoviaticos, :total, :float
  end
end

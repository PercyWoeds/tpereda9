class AddAsunto2ToAutoviaticos < ActiveRecord::Migration
  def change
    add_column :autoviaticos, :asunto2, :string
    add_column :autoviaticos, :lugar1, :string

    add_column :autoviaticos, :lugar2, :string
    add_column :autoviaticos, :lugar3, :string

  end
end

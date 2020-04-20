class AddAsunto1ToAutoviaticos < ActiveRecord::Migration
  def change
    add_column :autoviaticos, :asunto1, :string

    
  end
end

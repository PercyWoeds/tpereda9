class AddAlmacenIdToOutputs < ActiveRecord::Migration
  def change
    add_column :outputs, :almacen_id, :integer
  end
end

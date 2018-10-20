class AddEstadoToTransportorders < ActiveRecord::Migration
  def change
    add_column :tranportorders, :estado, :string
  end
end

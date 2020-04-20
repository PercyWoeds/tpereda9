class AddMotivoToRequerimientos < ActiveRecord::Migration
  def change
    add_column :requerimientos, :motivo, :string
  end
end

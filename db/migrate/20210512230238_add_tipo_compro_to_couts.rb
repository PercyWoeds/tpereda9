class AddTipoComproToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :tipo_compro, :string
  end
end

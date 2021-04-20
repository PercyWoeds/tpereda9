class AddDetalleToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :detalle, :string
  end
end

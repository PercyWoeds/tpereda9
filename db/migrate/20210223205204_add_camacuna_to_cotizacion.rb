class AddCamacunaToCotizacion < ActiveRecord::Migration
  def change
    add_column :cotizacions, :camacuna, :string
    add_column :cotizacions, :stand_by, :string

  end
end

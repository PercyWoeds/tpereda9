class AddCotizacioToServiceorders < ActiveRecord::Migration
  def change
    add_column :serviceorders, :cotiza, :string
    add_column :serviceorders, :fecha_entrega, :datetime 
    add_column :serviceorders, :otros, :string
  end
end

class AddCabeceraToInstruccions < ActiveRecord::Migration
  def change
    add_column :instruccions, :condicion, :string
    
  end
end

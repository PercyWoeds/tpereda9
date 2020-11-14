class AddCodeToCotizacions < ActiveRecord::Migration
  def change
  
	add_column :cotizacions, :tipo_unidad, :string
	add_column :cotizacions, :estado, :string


  end
end

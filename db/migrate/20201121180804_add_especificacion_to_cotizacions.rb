class AddEspecificacionToCotizacions < ActiveRecord::Migration
  def change
    add_column :cotizacions, :especifica, :string

	add_column :cotizacions, :tipo_unidad_id,  :integer
	add_column :cotizacions, :tipo_unidad2_id, :integer
	add_column :cotizacions, :tipo_unidad3_id, :integer

	add_column :cotizacions, :config_vehi_id,  :integer
	add_column :cotizacions, :config_vehi2_id, :integer
	add_column :cotizacions, :config_vehi3_id, :integer

	add_column :cotizacions, :qty, :float
	add_column :cotizacions, :qty2, :float
	add_column :cotizacions, :qty3, :float

	add_column :cotizacions, :price, :float
	add_column :cotizacions, :price2, :float
	add_column :cotizacions, :price3, :float

	add_column :cotizacions, :total, :float
	add_column :cotizacions, :total2, :float
	add_column :cotizacions, :total3, :float

    add_column :cotizacions, :tipounidad1, :float
	add_column :cotizacions, :tipounidad2, :float
	add_column :cotizacions, :tipounidad3, :float
	add_column :cotizacions, :tipounidad4, :float
	add_column :cotizacions, :tipounidad5, :float

	add_column :cotizacions, :tm, :integer 
	

	
	

  end
end

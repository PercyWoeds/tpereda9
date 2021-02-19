class AddTipoUnidad4IdToCotizacions < ActiveRecord::Migration
  def change
     add_column :cotizacions, :tipo_unidad4_id, :integer
     add_column :cotizacions, :config_vehi4_id, :integer
     add_column :cotizacions, :descrip4, :string
     add_column :cotizacions, :qty4, :float
     add_column :cotizacions, :price4, :float
     add_column :cotizacions, :total4, :float

	 add_column :cotizacions, :tipo_unidad5_id, :integer
     add_column :cotizacions, :config_vehi5_id, :integer
     add_column :cotizacions, :descrip5, :string
     add_column :cotizacions, :qty5, :float
     add_column :cotizacions, :price5, :float
     add_column :cotizacions, :total5, :float

     add_column :cotizacions, :tipo_unidad6_id, :integer
     add_column :cotizacions, :config_vehi6_id, :integer
     add_column :cotizacions, :descrip6, :string
     add_column :cotizacions, :qty6, :float
     add_column :cotizacions, :price6, :float
     add_column :cotizacions, :total6, :float

     add_column :cotizacions, :tipo_unidad7_id, :integer
     add_column :cotizacions, :config_vehi7_id, :integer
     add_column :cotizacions, :descrip7, :string
     add_column :cotizacions, :qty7, :float
     add_column :cotizacions, :price7, :float
     add_column :cotizacions, :total7, :float

     add_column :cotizacions, :tipo_unidad8_id, :integer
     add_column :cotizacions, :config_vehi8_id, :integer
     add_column :cotizacions, :descrip8, :string
     add_column :cotizacions, :qty8, :float
     add_column :cotizacions, :price8, :float
     add_column :cotizacions, :total8, :float

     add_column :cotizacions, :tipo_unidad9_id, :integer
     add_column :cotizacions, :config_vehi9_id, :integer
     add_column :cotizacions, :descrip9, :string
     add_column :cotizacions, :qty9, :float
     add_column :cotizacions, :price9, :float
     add_column :cotizacions, :total9, :float

     add_column :cotizacions, :tipo_unidad10_id, :integer
     add_column :cotizacions, :config_vehi10_id, :integer
     add_column :cotizacions, :descrip10, :string
     add_column :cotizacions, :qty10, :float
     add_column :cotizacions, :price10, :float
     add_column :cotizacions, :total10, :float




  end
end

class AddIqbfToTrucks < ActiveRecord::Migration
  def change
     add_column :trucks, :iqbf, :string

     add_column :trucks, :matpel, :string

	 add_column :trucks, :cert_habi, :string
	 add_column :trucks, :poliza_vehi, :string
	 
	 add_column :trucks, :soat, :string
	 add_column :trucks, :vmto_soat, :datetime

	 add_column :trucks, :tipo_revision, :string
	 add_column :trucks, :emision_rta, :datetime 
	 add_column :trucks, :vmto_rta, :datetime 

	 add_column :trucks, :emision_rts, :datetime
	 add_column :trucks, :vmto_rst, :datetime


  end
end

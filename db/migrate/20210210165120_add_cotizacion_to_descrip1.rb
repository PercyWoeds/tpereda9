class AddCotizacionToDescrip1 < ActiveRecord::Migration
  def change
  	
    add_column :cotizacions, :descrip1, :string
    add_column :cotizacions, :descrip2, :string
    add_column :cotizacions, :descrip3, :string

  end
end

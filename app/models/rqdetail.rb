class Rqdetail < ActiveRecord::Base
    attr_accessible :codigo, :qty, :unidad_id, :descrip, :placa_destino, :rqdetails_attributes
	 belongs_to :requerimiento 
	 belongs_to :unidad 
end

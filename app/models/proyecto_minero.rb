class ProyectoMinero < ActiveRecord::Base

	 validates_presence_of :descrip
	 validates_presence_of :punto_id

	 def generate_rq_number(serie)
    if ProyectoMinero.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+ ProyectoMinero.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
	end 
    end 

end

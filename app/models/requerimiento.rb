class Requerimiento < ActiveRecord::Base

	 belongs_to :employee


	 belongs_to :division 


	 validates_presence_of :employee_id, :division_id , :code, :fecha 
	  validates_uniqueness_of :code 
	

	def generate_rq_number(serie)
    if Requerimiento.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+Requerimiento.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
    end 
    
  end 
end

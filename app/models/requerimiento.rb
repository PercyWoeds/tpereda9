class Requerimiento < ActiveRecord::Base

	 belongs_to :employee


	 belongs_to :division 

	 belongs_to :user 


	 validates_presence_of :employee_id, :division_id , :code, :fecha 
	  validates_uniqueness_of :code 
	
	 has_many :rqdetails, :dependent => :destroy 
	 accepts_nested_attributes_for :rqdetails , reject_if: proc { |att| att['descrip'].blank?} , :allow_destroy => true



	 TABLE_HEADERS = ["ITEM",
	 "CODIGO",
	"CANTIDAD",
	"UND MEDIDA",
	"DESCRIPCION",
	"PLACA / DESTINO"]

	def generate_rq_number(serie)
    if Requerimiento.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+Requerimiento.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
	end 
    end 


	def get_processed
		if(self.processed == "1")
		  return "Aprobado "
	
		elsif (self.processed == "2")
		  
		  return "**Anulado **"
	
		elsif (self.processed == "3")
	
		  return "**Cancelado **"  
		else   
		  return "Not yet processed"
			
		end
	end
   
	


	def process
		if(self.processed == "1" or self.processed == true)          
		  self.processed="1"
		  self.date_processed = Time.now
		  self.save
		end
	end


	 
end

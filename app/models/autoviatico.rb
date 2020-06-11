class Autoviatico < ActiveRecord::Base

	 belongs_to :supplier 

   belongs_to :employee

	 before_save :set_total 

	def set_total
		self.total = self.movilidad + self.almuerzo + self.otros 
	end


  def generate_number(serie)
    if Autoviatico.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+Autoviatico.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
    end 
    
  end
  def get_empleado(id)
      a=Employee.find(id)
      return a.full_name2 
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

   def anular
    if(self.processed == "2" )          
      self.processed="2"
      
      
      self.date_processed = Time.now
      self.save
    end
  end

end

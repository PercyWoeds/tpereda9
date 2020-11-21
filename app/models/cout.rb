class Cout < ActiveRecord::Base



 def generate_ost_number(serie)
    if Cout.where("fecha  >?",serie,"2020-08-01 00:00:00")
    	.maximum("cast(substring(code,1,6)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+Cout.where("fecha  >?",serie,"2020-08-01 00:00:00").maximum("cast(substring(code,1,6)  as int)").next.to_s.rjust(6, '0') 
          
    end 
    
  end


end

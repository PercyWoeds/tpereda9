class Cout < ActiveRecord::Base


validates_presence_of :tranportorder_id,:employee_id,:truck_id,:importe  

belongs_to :employee
belongs_to :truck 
belongs_to :tranportorder


 def generate_cout_number
    if Cout.where("fecha  >?","2020-08-01 00:00:00")
    	.maximum("cast(substring(code,1,6)  as int)") == nil 
      	 self.code = "000001"
    else
   		 self.code = Cout.where("fecha  >?","2020-08-01 00:00:00").maximum("cast(substring(code,1,6)  as int)").next.to_s.rjust(6, '0') 
          
    end 
    
  end


end

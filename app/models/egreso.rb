class Egreso < ActiveRecord::Base

	 validates_uniqueness_of :code
    validates_presence_of :code, :name

    has_many  :viatico_details 

    def formatted_name 
    	"#{name} - #{extension}"

    	
      
    end


def get_detalle_egreso(viatico_id,id)
     
      @viaticos = ViaticoDetail.where("viatico_id = ? and egreso_id = ?",viatico_id, id).order(:fecha,:id,:document_id)
  end

  
def get_detalle_ingresotbk(viatico_id,id)
      lcCheque = 6
      @viaticos = ViaticotbkDetail.where("viaticotbk_id = ? and egreso_id = ?",viatico_id, id).order(:fecha,:id,:document_id)
      return @viaticos
 end  


  
def get_detalle_egresotbk(viatico_id,id)
      lcCheque = 6


        
        @viaticos0 = ViaticotbkDetail.where("viaticotbk_id = ? and egreso_id = ?",viatico_id, 17).order(:fecha,:id,:document_id)
  
     
            @viaticos =        ViaticotbkDetail.find_by_sql([' Select viaticotbk_details.*  
                 from viaticotbk_details 
                 INNER JOIN couts ON couts.id  = viaticotbk_details.cout_id 
                  where viaticotbk_id = ? and egreso_id = ? order by couts.code ',viatico_id, id])

  if  id == 17  

   return @viaticos + @viaticos0

 else

  return @viaticos 

 end  

  end



def get_detalle_egresotbk_fecha(id,fecha1,fecha2)
      lcCheque = 6

    
        
                   @viaticos = ViaticotbkDetail.find_by_sql([' Select viaticotbk_details.*  
                 from viaticotbk_details 
                 INNER JOIN couts ON couts.id  = viaticotbk_details.cout_id 
                 inner join viaticos on viaticos.id = viaticotbk_details.viaticotbk_id  
                  where egreso_id = ? and viaticos.fecha1 >= ? 
                  and viaticos.fecha1  <= ?  order by couts.code ', id , "#{fecha1} 00:00:00","#{fecha2} 23:59:59"])
     

      return @viaticos      
 

  end

def get_detalle_egresotbk_fecha2(viatico_id,id,fecha1,fecha2,empleado)
            
            @viaticos = ViaticotbkDetail.find_by_sql([' Select viaticotbk_details.*  
                 from viaticotbk_details 
                 INNER JOIN couts ON couts.id  = viaticotbk_details.cout_id 
                  inner join viaticos on viaticos.id = viaticotbk_details.viaticotbk_id  
                  where egreso_id = ? and viaticotbk_details.employee_id = ? and viaticos.fecha1 >= ? 
                  and viaticos.fecha1  <= ?  order by couts.code ',
                   id,empleado, "#{fecha1} 00:00:00","#{fecha2} 23:59:59"])
           return @viaticos      
 
end 






def get_detalle_egresolgv(viatico_id,id)
      lcCheque = 6
      @viaticos = ViaticolgvDetail.where("viaticolgv_id = ? and egreso_id = ?",viatico_id, id).order(:fecha,:id,:document_id)
  end

end

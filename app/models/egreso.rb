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

  
def get_detalle_egresotbk(viatico_id,id)
      lcCheque = 6
   #   @viaticos = ViaticotbkDetail.where("viaticotbk_id = ? and egreso_id = ?",viatico_id, id).order(:fecha,:id,:document_id)
  
          @viaticos =        ViaticotbkDetail.find_by_sql([' Select viaticotbk_details.*  
                 from viaticotbk_details 
                 INNER JOIN couts ON couts.id  = viaticotbk_details.cout_id 
                  where viaticotbk_id = ? and egreso_id = ? order by couts.code ',viatico_id, id])
   return @viaticos


  end



def get_detalle_egresolgv(viatico_id,id)
      lcCheque = 6
      @viaticos = ViaticolgvDetail.where("viaticolgv_id = ? and egreso_id = ?",viatico_id, id).order(:fecha,:id,:document_id)
  end

end

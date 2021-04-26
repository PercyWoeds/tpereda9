class Egreso < ActiveRecord::Base

	 validates_uniqueness_of :code
    validates_presence_of :code, :name

    has_many  :viatico_details 

    def formatted_name 
    	"#{name} - #{extension}"

    	
      
    end
def get_detalle_egreso(viatico_id,id)
      lcCheque = 6
      @viaticos = ViaticoDetail.where("viatico_id = ? and egreso_id = ?",viatico_id, id).order(:fecha,:id,:document_id)
  end

  
def get_detalle_egresotbk(viatico_id,id)
      lcCheque = 6
      @viaticos = ViaticotbkDetail.where("viaticotbk_id = ? and egreso_id = ?",viatico_id, id).order(:fecha,:id,:document_id)
  end

end

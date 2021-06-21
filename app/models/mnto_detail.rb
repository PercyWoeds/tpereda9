class MntoDetail < ActiveRecord::Base
  belongs_to :mnto
  belongs_to :activity

  validates_presence_of :mnto_id,  :activity_id ,:process 


  def get_estado

  	if(self.process == "0")
      return " "
    else
    	if(self.process == "1")
           return "Proceso"
       else 
           return "Ejecutado"
       end 
    end

  end 
end

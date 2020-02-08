class Telecredito < ActiveRecord::Base 

	belongs_to :bank_acount 

	  has_many :telecredito_details, :dependent => :destroy
	  def get_processed
    if(self.processed == "1")
      return "Procesado"
    else
      return "No Procesado"
    end
  end
  
end

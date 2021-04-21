class LvtDelivery < ActiveRecord::Base
	 validates_presence_of :lvt_id, :compro_id,  :importe 
  
    belongs_to :lgv 
    belongs_to :compro


end

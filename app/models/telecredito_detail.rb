class TelecreditoDetail < ActiveRecord::Base

	self.per_page = 20
    
    belongs_to :telecreditos 
end

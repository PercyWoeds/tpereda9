class QuotationDetail < ActiveRecord::Base
    self.per_page = 20
    
    belongs_to :quotations 
    validates_presence_of :quotation_id, :descrip
    
end

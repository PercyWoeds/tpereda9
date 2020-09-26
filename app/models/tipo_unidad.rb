class TipoUnidad < ActiveRecord::Base


	validates_uniqueness_of :code
    validates_presence_of :code,:name,:user_id,:company_id
    
      belongs_to :truck 
end
